{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./git.nix
    ./langs
    ./theme.nix
    ./treesitter.nix
  ];

  programs = {
    neovim = {
      enable = true;

      extraLuaConfig =
        # lua
        ''
          -- by default, the indent is 2 spaces.
          vim.opt.smartindent = true;
          vim.opt.expandtab = true;
          vim.opt.shiftwidth = 2;
          vim.opt.softtabstop = 2;
          vim.opt.tabstop = 2;

          vim.opt.number = true;
          vim.opt.relativenumber = true;

          vim.opt.undofile = true;
          vim.opt.undodir = '${config.xdg.cacheHome}/nvim/';

          -- Always show the signcolumn, otherwise it would shift
          -- the text each time diagnostics appear/become resolved
          vim.opt.signcolumn = 'yes';

          -- remove highlight on words
          vim.keymap.set('n', '<esc>', ':noh<cr><esc>', {
            noremap = true,
            silent = true,
          });

          -- Get rid of deprecated messages
          vim.tbl_add_reverse_lookup = function(tbl)
              for k, v in pairs(tbl) do
                  tbl[v] = k;
              end
          end;
          vim.tbl_islist = function(tbl)
              return vim.islist(tbl);
          end;
          vim.diagnostic.is_disabled = function()
              return not vim.diagnostic.is_enabled();
          end;
          vim.lsp.buf_get_clients = function()
              return vim.lsp.get_clients();
          end;
          vim.lsp.get_active_clients = function()
              return vim.lsp.get_clients();
          end;
        '';

      plugins = [
        pkgs.vimPlugins.fzfWrapper
        pkgs.vimPlugins.fzf-vim

        {
          plugin = pkgs.vimPlugins.todo-comments-nvim;
          type = "lua";
          config =
            # lua
            ''
              require('todo-comments').setup();
            '';
        }
        {
          plugin = pkgs.vimPlugins.mini-nvim;
          type = "lua";
          config =
            # lua
            ''
              -- TODO: see how this works
              local ts_input = require('mini.surround').gen_spec.input.treesitter;

              require('mini.surround').setup({
                  custom_surroundings = {
                      -- Use tree-sitter to search for function call
                      f = {
                          input = ts_input({
                            outer = '@call.outer',
                            inner = '@call.inner',
                          });
                      },
                  },
              });
            '';
        }
      ];
    };
  };
}
