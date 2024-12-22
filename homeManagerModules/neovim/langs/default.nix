self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) fileContents mkBefore mkIf;

  cfg = config.programs.neovim;
in {
  imports = [
    ./bash
    ./c-lang
    ./hyprlang
    ./java
    ./json
    ./lua
    ./python
    ./rust

    (import ./csharp self)
    (import ./markdown self)
    (import ./nix-lang self)
    (import ./web self)
  ];

  # FIXME: try making LSPs and stuff only available through devShells
  config.programs = mkIf cfg.enableIde {
    neovim = {
      extraLuaConfig =
        mkBefore
        # lua
        ''
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
        (builtins.attrValues {
          inherit
            (pkgs.vimPlugins)
            nvim-lspconfig
            lsp-status-nvim
            lsp_lines-nvim
            cmp-buffer
            cmp-nvim-lsp
            cmp-path
            cmp-spell
            vim-vsnip
            ;
        })
        ++ [
          {
            plugin = pkgs.vimPlugins.nvim-cmp;
            type = "lua";
            config = fileContents ./config/cmp.lua;
          }

          {
            plugin = pkgs.vimPlugins.nvim-autopairs;
            type = "lua";
            config =
              # lua
              ''
                require('nvim-autopairs').setup({});
              '';
          }
        ];
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
