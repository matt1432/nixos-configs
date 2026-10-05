self: {
  config,
  lib,
  options,
  pkgs,
  ...
}: let
  inherit (lib) concatMapStringsSep fileContents getName mkBefore mkEnableOption mkIf mkMerge mkOption mkOrder types;

  cfg = config.programs.neovim;

  guardLua = code: ''
    if not vim.g.vscode then
    ${code}
    end
  '';

  guardConfig = type: code:
    if type == "lua"
    then guardLua code
    else if type == "viml"
    then ''
      if !exists('g:vscode')
      ${code}
      endif
    ''
    else throw "programs.neovim.vscode.excludedPlugins: unsupported config type '${type}'";

  normalizePlugin = p:
    if p ? plugin
    then p
    else {
      plugin = p;
      config = null;
      optional = false;
    };

  excludedPlugins = map normalizePlugin cfg.vscode.excludedPlugins;

  # Make the plugins optional so they don't load under vscode-neovim, then add them back to the
  # runtimepath with `packadd!` otherwise. The bang defers sourcing their plugin/ files to the
  # usual startup step, like start plugins, and `mkOrder 0` makes them `require`-able from all of initLua.
  packaddExcludedPlugins =
    guardLua (concatMapStringsSep "\n" (p: ''vim.cmd("packadd! ${getName p.plugin}")'')
      (builtins.filter (p: !p.optional) excludedPlugins));

  guardPlugin = p:
    p
    // {
      optional = true;
      config =
        if p.config == null
        then null
        else guardConfig p.type p.config;
    };
in {
  imports = [
    (import ./git self)
    (import ./langs self)
    (import ./llms self)
    (import ./theme self)
  ];

  options.programs.neovim = {
    user = mkOption {
      type = types.str;
    };

    ideConfig = {
      llmProvider = mkOption {
        type = types.enum ["llama_cpp" "none"];
        default = "llama_cpp";
      };

      enableBash = mkOption {
        type = types.bool;
        default = true;
      };
      enableJava = mkOption {
        type = types.bool;
        default = true;
      };
      enableNix = mkOption {
        type = types.bool;
        default = true;
      };
      enableWeb = mkOption {
        type = types.bool;
        default = true;
      };
    };

    vscode = {
      enable = mkEnableOption ''
        compatibility with vscode-neovim. Plugins and settings declared in
        `excludedPlugins` and `excludedInitLua` are skipped when `vim.g.vscode` is set
      '';

      excludedPlugins = mkOption {
        inherit (options.programs.neovim.plugins) type;
        default = [];
        description = ''
          Plugins that aren't loaded under vscode-neovim when `vscode.enable` is set.
          They are added to `plugins` either way.
        '';
      };

      excludedInitLua = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Lua code that doesn't run under vscode-neovim when `vscode.enable` is set.
          It is added to the start of `initLua` either way.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    programs.neovim = mkMerge [
      {
        plugins =
          if cfg.vscode.enable
          then map guardPlugin excludedPlugins
          else excludedPlugins;

        initLua = mkMerge [
          (mkIf cfg.vscode.enable (mkOrder 0 packaddExcludedPlugins))

          (mkIf cfg.vscode.enable ''
            if vim.g.vscode then
                vim.g.clipboard = {
                    name = 'WslClipboard',
                    copy = {
                        ['+'] = 'clip.exe',
                        ['*'] = 'clip.exe',
                    },
                    paste = {
                        ['+'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                        ['*'] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                    },
                    cache_enabled = 0,
                };
            end
          '')

          (mkBefore (
            if cfg.vscode.enable
            then guardLua cfg.vscode.excludedInitLua
            else cfg.vscode.excludedInitLua
          ))
        ];
      }

      {
        # Not rendered or overridden by vscode-neovim
        vscode.excludedInitLua =
          # lua
          ''
            vim.opt.fillchars = {}
            vim.opt.fillchars:append({
                eob = " ",
                vert = "▕",
                diff = "╱",
                msgsep = "‾",
            })

            vim.opt.number = true
            vim.opt.relativenumber = true

            -- Buffers are loaded from VSCode, so the undo files wouldn't match
            vim.opt.undofile = true
            vim.opt.undodir = vim.fn.expand("~/.local/state/nvim/undo/")

            -- Always show the signcolumn, otherwise it would shift
            -- the text each time diagnostics appear/become resolved
            vim.opt.signcolumn = "yes"

            -- https://github.com/seblj/roslyn.nvim/issues/121#issuecomment-2544076963
            vim.opt.cmdheight = 2
          '';

        vscode.excludedPlugins = [
          pkgs.vimPlugins.fzf-wrapper
          pkgs.vimPlugins.fzf-vim

          pkgs.vimPlugins.plenary-nvim # Needed for telescope-nvim
          pkgs.vimPlugins.telescope-fzf-native-nvim
          {
            plugin = pkgs.vimPlugins.telescope-nvim;
            type = "lua";
            config = ''
              local telescope = require("telescope")

              telescope.setup({
                  extensions = {
                      fzf = {
                          fuzzy = true,
                          override_generic_sorter = true,
                          override_file_sorter = true,
                      },
                  },
              })
              telescope.load_extension("fzf")

              vim.keymap.set(
                  "n",
                  "<C-RightMouse>",
                  require("telescope.builtin").lsp_references,
                  { noremap = true, silent = true }
              )
            '';
          }

          {
            plugin = pkgs.vimPlugins.todo-comments-nvim;
            type = "lua";
            config = ''
              require("todo-comments").setup()
            '';
          }

          {
            plugin = pkgs.vimPlugins.nvim-config-local;
            type = "lua";
            config = ''
              require("config-local").setup({
                  config_files = { ".nvim.lua", ".nvimrc", ".exrc" },

                  -- Where the plugin keeps files data
                  hashfile = vim.fn.expand("~/.local/state/nvim/config-local/"),
              })
            '';
          }

          # vscode-neovim maps zR, zM, etc. to VSCode's folding
          {
            plugin = pkgs.vimPlugins.nvim-ufo;
            type = "lua";
            config = fileContents ./config/ufo.lua;
          }
        ];
      }

      {
        withPython3 = true;
        withRuby = true;

        initLua =
          # lua
          ''
            -- by default, the indent is 2 spaces.
            vim.opt.smartindent = true
            vim.opt.expandtab = true
            vim.opt.shiftwidth = 2
            vim.opt.softtabstop = 2
            vim.opt.tabstop = 2

            -- remove highlight on words
            vim.keymap.set("n", "<esc>", ":noh<cr><esc>", {
                noremap = true,
                silent = true,
            })

            -- To help debugging
            table.print = function(tab, exclusions)
                local nests = 0

                if not exclusions then
                    exclusions = {}
                end

                local recurse = function(t, recurse, excl)
                    local indent = function()
                        for _ = 1, nests do
                            io.write("    ")
                        end
                    end

                    local excluded = function(key)
                        for _, v in pairs(excl) do
                            if v == key then
                                return true
                            end
                        end

                        return false
                    end

                    local isFirst = true

                    for k, v in pairs(t) do
                        if isFirst then
                            indent()
                            print("|")
                            isFirst = false
                        end

                        if type(v) == "table" and not excluded(k) then
                            indent()
                            print("|-> " .. k .. ": " .. type(v))
                            nests = nests + 1
                            recurse(v, recurse, excl)
                        elseif excluded(k) then
                            indent()
                            print("|-> " .. k .. ": " .. type(v))
                        elseif type(v) == "userdata" or type(v) == "function" then
                            indent()
                            print("|-> " .. k .. ": " .. type(v))
                        elseif type(v) == "string" then
                            indent()
                            print("|-> " .. k .. ": " .. '"' .. v .. '"')
                        elseif v then
                            indent()
                            print("|-> " .. k .. ": true")
                        else
                            indent()
                            print("|-> " .. k .. ": false")
                        end
                    end

                    nests = nests - 1
                end

                nests = 0

                print("### START TABLE ###")

                for k, v in pairs(tab) do
                    print("root")

                    if type(v) == "table" then
                        print("|-> " .. k .. ": " .. type(v))
                        nests = nests + 1
                        recurse(v, recurse, exclusions)
                    elseif type(v) == "userdata" or type(v) == "function" then
                        print("|-> " .. k .. ": " .. type(v))
                    elseif type(v) == "string" then
                        print("|-> " .. k .. ": " .. '"' .. v .. '"')
                    else
                        print("|-> " .. k .. ": " .. v)
                    end
                end

                print("### END TABLE ###")
            end
          '';

        plugins = [
          {
            plugin = pkgs.vimPlugins.mini-nvim;
            type = "lua";
            config = fileContents ./config/mini.lua;
          }
        ];
      }
    ];
  };

  # For accurate stack trace
  _file = ./default.nix;
}
