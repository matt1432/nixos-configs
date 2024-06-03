{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.vars) neovimIde;
  inherit (pkgs) vimPlugins;
in {
  imports = [
    ./bash.nix
    ./clang.nix
    ./hyprlang.nix
    ./java.nix
    ./json.nix
    ./lua.nix
    ./markdown.nix
    ./nix.nix
    ./python.nix
    ./rust.nix
    ./web.nix
  ];

  programs = lib.mkIf neovimIde {
    neovim = {
      extraLuaConfig =
        lib.mkBefore
        /*
        lua
        */
        ''
          -- Get rid of deprecated functions
          vim.tbl_add_reverse_lookup = function(tbl)
              for k, v in pairs(tbl) do
                  tbl[v] = k;
              end
          end;
          vim.diagnostic.is_disabled = function()
              return not vim.diagnostic.is_enabled();
          end;
          vim.tbl_islist = function(tbl)
              return vim.islist(tbl);
          end;
          vim.lsp.buf_get_clients = function()
              return vim.lsp.get_clients();
          end;

          -- Start completion / snippet stuff
          vim.g.coq_settings = {
            auto_start = 'shut-up',
            keymap = {
              recommended = false,
            },
            -- https://github.com/NixOS/nixpkgs/issues/168928#issuecomment-1109581739
            xdg = true,
          };

          -- Add formatting cmd
          vim.api.nvim_create_user_command(
              'Format',
              function()
                  vim.lsp.buf.format({ async = true });
              end,
              {}
          );

          -- LSP-Status setup
          local lsp_status = require('lsp-status');
          lsp_status.register_progress();

          -- Remove LSP highlighting to use Treesitter
          vim.api.nvim_create_autocmd("LspAttach", {
              callback = function(args)
                  local client = vim.lsp.get_client_by_id(args.data.client_id);
                  client.server_capabilities.semanticTokensProvider = nil;
                  lsp_status.on_attach(client);
              end,
          });

          -- Disable virtual_text since it's redundant due to lsp_lines.
          vim.diagnostic.config({
              virtual_text = false,
          });

          require('lsp_lines').setup();

          -- Autopairs with coq
          local remap = vim.api.nvim_set_keymap
          local npairs = require('nvim-autopairs')

          npairs.setup({ map_bs = false, map_cr = false })

          _G.MUtils= {}

          MUtils.CR = function()
              if vim.fn.pumvisible() ~= 0 then
                  if vim.fn.complete_info({ 'selected' }).selected ~= -1 then
                      return npairs.esc('<c-y>');
                  else
                      return npairs.esc('<c-e>') .. npairs.autopairs_cr();
                  end
              else
                  return npairs.autopairs_cr();
              end
          end
          remap('i', '<cr>', 'v:lua.MUtils.CR()', { expr = true, noremap = true });

          MUtils.BS = function()
              if vim.fn.pumvisible() ~= 0 and vim.fn.complete_info({ 'mode' }).mode == 'eval' then
                  return npairs.esc('<c-e>') .. npairs.autopairs_bs();
              else
                  return npairs.autopairs_bs();
              end
          end
          remap('i', '<bs>', 'v:lua.MUtils.BS()', { expr = true, noremap = true });
        '';

      plugins = [
        vimPlugins.nvim-lspconfig

        vimPlugins.coq_nvim
        vimPlugins.coq-artifacts
        vimPlugins.coq-thirdparty

        vimPlugins.nvim-autopairs

        vimPlugins.lsp-status-nvim
        vimPlugins.lsp_lines-nvim
      ];
    };
  };
}
