{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (config.vars) neovimIde;
  inherit (pkgs) vimPlugins;
  inherit (lib) fileContents;
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
        # lua
        ''
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
          vim.api.nvim_create_autocmd('LspAttach', {
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

      plugins =
        (with vimPlugins; [
          nvim-lspconfig
          lsp-status-nvim
          lsp_lines-nvim

          cmp-buffer
          cmp-nvim-lsp
          cmp-path
          cmp-spell
          cmp-treesitter
          cmp-vsnip
          vim-vsnip
          friendly-snippets
        ])
        ++ [
          {
            plugin = vimPlugins.nvim-cmp;
            type = "lua";
            config = fileContents ../plugins/cmp.lua;
          }

          {
            plugin = vimPlugins.nvim-autopairs;
            type = "lua";
            config =
              # lua
              "require('nvim-autopairs').setup({})";
          }
        ];
    };
  };
}
