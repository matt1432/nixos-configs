{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.vars) neovimIde;
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
            vim.api.nvim_create_user_command("Format", "call CocAction('format')", {});

            -- Always show the signcolumn, otherwise it would shift the text each time
            -- diagnostics appear/become resolved
            vim.opt.signcolumn = 'yes';
          '';

        plugins = [
          {
            plugin = vimPlugins.coc-snippets;
            type = "viml";
            config =
              /*
              vim
              */
              ''
                " use vscode keybinds for snippets completion
                inoremap <silent><expr> <TAB>
                    \ coc#pum#visible() ? coc#_select_confirm() :
                    \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump','''])\<CR>" :
                    \ CheckBackspace() ? "\<TAB>" :
                    \ coc#refresh()

                function! CheckBackspace() abort
                    let col = col('.') - 1
                    return !col || getline('.')[col - 1]  =~# '\s'
                endfunction

                let g:coc_snippet_next = '<tab>'
              '';
          }

          ## Fzf
          vimPlugins.coc-fzf

          vimPlugins.coc-highlight
          vimPlugins.coc-json
          vimPlugins.coc-yaml
          vimPlugins.coc-toml

          {
            plugin = vimPlugins.nvim-autopairs;
            type = "lua";
            config =
              /*
              lua
              */
              ''
                -- Auto indent when pressing Enter between brackets
                local remap = vim.api.nvim_set_keymap
                local npairs = require('nvim-autopairs')
                npairs.setup({map_cr=false})

                _G.MUtils= {}

                MUtils.completion_confirm=function()
                    if vim.fn["coc#pum#visible"]() ~= 0  then
                        return vim.fn["coc#pum#confirm"]()
                    else
                        return npairs.autopairs_cr()
                    end
                end

                remap('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true , noremap = true})
              '';
          }
        ];
      };
    };
  }
