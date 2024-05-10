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
    ./lua.nix
    ./markdown.nix
    ./nix.nix
    ./python.nix
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
          -- Start completion / snippet stuff
          vim.g.coq_settings = { auto_start = 'shut-up' };

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
        '';
      plugins = [
        vimPlugins.nvim-lspconfig

        vimPlugins.coq_nvim
        vimPlugins.coq-artifacts
        vimPlugins.coq-thirdparty

        vimPlugins.lsp-status-nvim
        vimPlugins.lsp_lines-nvim
      ];
    };
  };
}
