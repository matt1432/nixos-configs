self: {
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (self.inputs) nvim-theme-src;
  inherit (self.lib.${pkgs.stdenv.hostPlatform.system}) mkVersion;

  inherit (lib) attrValues fileContents getExe mkIf;

  cfg = config.programs.neovim;
in {
  imports = [./treesitter.nix];

  config = mkIf cfg.enable {
    programs.neovim = {
      extraPackages = attrValues {
        inherit (pkgs) bat;
      };

      plugins = [
        {
          plugin = pkgs.vimPlugins.dracula-nvim.overrideAttrs (o: {
            name = "vimplugin-${o.pname}-${mkVersion nvim-theme-src}";
            src = nvim-theme-src;
          });
          type = "lua";
          config =
            # lua
            ''
              -- set dot icon in place of trailing whitespaces
              vim.opt.listchars = {
                  tab = '→ ',
                  trail = '•',
                  extends = '⟩',
                  precedes = '⟨',
                  nbsp = '␣',
              };
              vim.opt.list = true;

              -- Add visual indicator for trailing whitespaces
              vim.opt.fillchars = { eob = " " };
              vim.fn.matchadd('errorMsg', [[\s\+$]]);

              vim.cmd.colorscheme('dracula');
            '';
        }
        {
          plugin = pkgs.vimPlugins.indent-blankline-nvim;
          type = "lua";
          config =
            # lua
            ''
              --
              local highlight = {
                  "RainbowRed",
                  "RainbowYellow",
                  "RainbowBlue",
                  "RainbowOrange",
                  "RainbowGreen",
                  "RainbowViolet",
                  "RainbowCyan",
              };

              local hooks = require('ibl.hooks');
              hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                  vim.api.nvim_set_hl(0, "RainbowRed",    { fg = "#E06C75" });
                  vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" });
                  vim.api.nvim_set_hl(0, "RainbowBlue",   { fg = "#61AFEF" });
                  vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" });
                  vim.api.nvim_set_hl(0, "RainbowGreen",  { fg = "#98C379" });
                  vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" });
                  vim.api.nvim_set_hl(0, "RainbowCyan",   { fg = "#56B6C2" });
              end);

              require('ibl').setup({
                  indent = {
                      highlight = highlight,
                      char = "▏",
                  },
              });
            '';
        }

        {
          plugin = pkgs.vimPlugins.nvim-highlight-colors;
          type = "lua";
          config =
            # lua
            ''
              -- Ensure termguicolors is enabled if not already
              vim.opt.termguicolors = true;

              require('nvim-highlight-colors').setup({});
            '';
        }

        # Deps of heirline config
        pkgs.vimPlugins.nvim-web-devicons
        {
          plugin = pkgs.vimPlugins.heirline-nvim;
          type = "lua";
          config = fileContents ./config/heirline.lua;
        }

        {
          plugin = pkgs.vimPlugins.neo-tree-nvim.overrideAttrs (o: {
            postPatch = ''
              ${o.postPatch or ""}
              for file in $(${pkgs.findutils}/bin/find ./lua/neo-tree -type f -name "*.lua"); do
                  substituteInPlace "$file" --replace-warn '"git"' '"${getExe pkgs.gitFull}"'
              done
            '';
          });
          type = "lua";
          config = fileContents ./config/neotree.lua;
        }
        {
          plugin = pkgs.vimPlugins.transparent-nvim;
          type = "lua";
          config =
            # lua
            ''
              require('transparent').setup({
                  groups = {
                      'Normal',
                      'NormalNC',
                      'Comment',
                      'Constant',
                      'Special',
                      'Identifier',
                      'Statement',
                      'PreProc',
                      'Type',
                      'Underlined',
                      'Todo',
                      'String',
                      'Function',
                      'Conditional',
                      'Repeat',
                      'Operator',
                      'Structure',
                      'LineNr',
                      'NonText',
                      'SignColumn',
                      'CursorLine',
                      'CursorLineNr',
                      'StatusLine',
                      'StatusLineNC',
                      'EndOfBuffer',
                  },
                  extra_groups = {},
                  exclude_groups = {},
              });
            '';
        }
      ];
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
