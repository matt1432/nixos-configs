self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) fileContents mkIf mkOption types;

  cfg = config.programs.neovim;
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
        type = types.enum ["cursor" "opencode" "none"];
        default = "opencode";
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
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      withPython3 = true;
      withRuby = true;

      initLua =
        # lua
        ''
          vim.opt.fillchars = {};
          vim.opt.fillchars:append({
              eob = ' ',
              vert = '▕',
              diff = '╱',
              msgsep = '‾',
          });

          -- by default, the indent is 2 spaces.
          vim.opt.smartindent = true;
          vim.opt.expandtab = true;
          vim.opt.shiftwidth = 2;
          vim.opt.softtabstop = 2;
          vim.opt.tabstop = 2;

          vim.opt.number = true;
          vim.opt.relativenumber = true;

          vim.opt.undofile = true;
          vim.opt.undodir = vim.fn.expand("~/.local/state/nvim/undo/");

          -- Always show the signcolumn, otherwise it would shift
          -- the text each time diagnostics appear/become resolved
          vim.opt.signcolumn = 'yes';

          -- remove highlight on words
          vim.keymap.set('n', '<esc>', ':noh<cr><esc>', {
              noremap = true,
              silent = true,
          });

          -- https://github.com/seblj/roslyn.nvim/issues/121#issuecomment-2544076963
          vim.opt.cmdheight = 2;

          -- To help debugging
          table.print = function(tab, exclusions)
              local nests = 0;

              if not exclusions then
                  exclusions = {};
              end;

              local recurse = function(t, recurse, excl)
                  local indent = function()
                      for _ = 1, nests do
                          io.write('    ');
                      end;
                  end;

                  local excluded = function(key)
                      for _, v in pairs(excl) do
                          if v == key then
                              return true;
                          end;
                      end;

                      return false;
                  end;

                  local isFirst = true;

                  for k, v in pairs(t) do
                      if isFirst then
                          indent();
                          print('|');
                          isFirst = false;
                      end;

                      if type(v) == 'table' and not excluded(k) then
                          indent();
                          print('|-> ' .. k .. ': ' .. type(v));
                          nests = nests + 1;
                          recurse(v, recurse, excl);
                      elseif excluded(k) then
                          indent();
                          print('|-> ' .. k .. ': ' .. type(v));
                      elseif type(v) == 'userdata' or type(v) == 'function' then
                          indent();
                          print('|-> ' .. k .. ': ' .. type(v));
                      elseif type(v) == 'string' then
                          indent();
                          print('|-> ' .. k .. ': ' .. '\"' .. v .. '\"');
                      elseif v then
                          indent();
                          print('|-> ' .. k .. ': true');
                      else
                          indent();
                          print('|-> ' .. k .. ': false');
                      end;
                  end;

                  nests = nests - 1;
              end;

              nests = 0;

              print('### START TABLE ###');

              for k, v in pairs(tab) do
                  print('root');

                  if type(v) == 'table' then
                      print('|-> ' .. k .. ': ' .. type(v));
                      nests = nests + 1;
                      recurse(v, recurse, exclusions);
                  elseif type(v) == 'userdata' or type(v) == 'function' then
                      print('|-> ' .. k .. ': ' .. type(v));
                  elseif type(v) == 'string' then
                      print('|-> ' .. k .. ': ' .. '\"' .. v .. '\"');
                  else
                      print('|-> ' .. k .. ': ' .. v);
                  end;
              end;

              print('### END TABLE ###');
          end;
        '';

      plugins = [
        pkgs.vimPlugins.fzf-wrapper
        pkgs.vimPlugins.fzf-vim

        pkgs.vimPlugins.plenary-nvim # Needed for telescope-nvim
        pkgs.vimPlugins.telescope-fzf-native-nvim
        {
          plugin = pkgs.vimPlugins.telescope-nvim;
          type = "lua";
          config = ''
            local telescope = require("telescope");

            telescope.setup({
                extensions = {
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                    },
                },
            });
            telescope.load_extension('fzf');

            vim.keymap.set(
                'n',
                '<C-RightMouse>',
                require('telescope.builtin').lsp_references,
                { noremap = true, silent = true }
            );
          '';
        }

        {
          plugin = pkgs.vimPlugins.todo-comments-nvim;
          type = "lua";
          config = ''
            require('todo-comments').setup();
          '';
        }
        {
          plugin = pkgs.vimPlugins.mini-nvim;
          type = "lua";
          config = fileContents ./config/mini.lua;
        }

        {
          plugin = pkgs.vimPlugins.nvim-config-local;
          type = "lua";
          config = ''
            require('config-local').setup({
                config_files = { '.nvim.lua', '.nvimrc', '.exrc' },

                -- Where the plugin keeps files data
                hashfile = vim.fn.expand("~/.local/state/nvim/config-local/"),
            });
          '';
        }

        {
          plugin = pkgs.vimPlugins.nvim-ufo;
          type = "lua";
          config = fileContents ./config/ufo.lua;
        }
      ];
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
