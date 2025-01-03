self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.inputs) nix-develop-nvim-src;
  inherit (self.lib.${pkgs.system}) mkVersion;

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

  config = mkIf cfg.enable {
    programs.neovim = {
      extraLuaConfig =
        mkBefore
        # lua
        ''
          -- Init object to keep track of loaded devShells
          local devShells = {};

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
        '';

      plugins =
        (builtins.attrValues {
          inherit
            (pkgs.vimPlugins)
            # lsp plugins
            nvim-lspconfig
            lsp-status-nvim
            # completion plugins
            cmp-buffer
            cmp-nvim-lsp
            cmp-path
            cmp-spell
            vim-vsnip
            ;
        })
        ++ [
          (pkgs.vimPlugins.nix-develop-nvim.overrideAttrs (o: {
            name = "vimplugin-${o.pname}-${mkVersion nix-develop-nvim-src}";
            src = nix-develop-nvim-src;
          }))

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

          {
            plugin = pkgs.vimPlugins.lsp_lines-nvim;
            type = "lua";
            config =
              # lua
              ''
                -- Disable virtual_text since it's redundant due to lsp_lines.
                vim.diagnostic.config({
                    virtual_text = false,
                });

                require('lsp_lines').setup();
              '';
          }
        ];
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
