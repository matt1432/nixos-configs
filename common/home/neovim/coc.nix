{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.vars) neovimIde;
  inherit (lib) fileContents;
  inherit (pkgs) vimPlugins;
in
  lib.mkIf neovimIde {
    programs = {
      neovim = {
        coc = {
          enable = true;
          settings = {
            colors.enable = true;
            coc.preferences.formatOnType = true;
            diagnostic.checkCurrentLine = true;
            inlayHint.enable = false;
          };
        };

        extraLuaConfig =
          /*
          lua
          */
          ''
            vim.api.nvim_create_autocmd("FileType", {
               pattern = 'hyprlang',
               command = 'setlocal ts=4 sw=4 sts=0 expandtab',
            });

            vim.api.nvim_create_user_command("Format", "call CocAction('format')", {});

            -- Always show the signcolumn, otherwise it would shift the text each time
            -- diagnostics appear/become resolved
            vim.opt.signcolumn = 'yes';
          '';

        plugins = [
          {
            plugin = vimPlugins.coc-snippets;
            type = "viml";
            config = fileContents ./plugins/snippets.vim;
          }

          ## Fzf
          vimPlugins.coc-fzf

          vimPlugins.coc-highlight
          vimPlugins.coc-json
          vimPlugins.coc-yaml
          vimPlugins.coc-toml
        ];
      };
    };
  }
