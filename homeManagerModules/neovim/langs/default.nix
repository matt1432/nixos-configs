self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.inputs) nix-develop-nvim-src;
  inherit (self.lib.${pkgs.system}) mkVersion;

  inherit (lib) attrValues fileContents mkBefore mkIf;

  cfg = config.programs.neovim;
in {
  imports = [
    ./bash
    ./c-lang
    ./golang
    ./hyprlang
    ./java
    ./json
    ./kotlin
    ./lua
    ./python
    ./qml
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

      plugins = attrValues {
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

        nix-develop-nvim = pkgs.vimPlugins.nix-develop-nvim.overrideAttrs (o: {
          name = "vimplugin-${o.pname}-${mkVersion nix-develop-nvim-src}";
          src = nix-develop-nvim-src;
        });

        nvim-cmp = {
          plugin = pkgs.vimPlugins.nvim-cmp;
          type = "lua";
          config = fileContents ./config/cmp.lua;
        };

        nvim-autopairs = {
          plugin = pkgs.vimPlugins.nvim-autopairs;
          type = "lua";
          config =
            # lua
            ''
              require('nvim-autopairs').setup({});
            '';
        };

        tiny-inline-diagnostic = {
          plugin = pkgs.vimPlugins.tiny-inline-diagnostic-nvim;
          type = "lua";
          config =
            # lua
            ''
              -- Disable virtual_text since it's redundant due to tiny-inline-diagnostic.
              vim.diagnostic.config({
                  virtual_text = false,
              });

              require("tiny-inline-diagnostic").setup({
                  -- Available options:
                  -- "modern", "classic", "minimal", "powerline",
                  -- "ghost", "simple", "nonerdfont", "amongus"
                  preset = 'modern',

                  options = {
                      show_source = true,
                      use_icons_from_diagnostic = false,

                      -- Minimum message length before wrapping to a new line
                      softwrap = 30,

                      -- Show all diagnostics under the cursor if multiple diagnostics exist on the same line
                      -- If set to false, only the diagnostics under the cursor will be displayed
                      multiple_diag_under_cursor = true,

                      multilines = {
                          enabled = true,
                          always_show = true,
                      },

                      enable_on_insert = true,
                      throttle = 0,
                  },
              });
            '';
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
