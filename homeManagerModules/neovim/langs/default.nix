self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.inputs) vimplugin-nix-develop-src;
  inherit (self.lib.${pkgs.stdenv.hostPlatform.system}) mkVersion;

  inherit (builtins) attrValues;
  inherit (lib) fileContents mkBefore mkIf;

  cfg = config.programs.neovim;
  flakeEnv = config.programs.bash.sessionVariables.FLAKE;
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
    ./ocaml
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
      initLua =
        mkBefore
        # lua
        ''
          --
          local nix_develop = require('nix-develop');
          local default_capabilities = require('cmp_nvim_lsp').default_capabilities();

          -- Init object to keep track of loaded devShells
          local devShells = {};

          --- @param name string
          --- @param pattern string|string[]
          --- @param pre_shell_callback function
          --- @param language_servers function?
          --- @param post_shell_callback fun(bufnr: integer)?
          local loadDevShell = function(args)
              local name = args.name;
              local pattern = args.pattern;
              local pre_shell_callback = args.pre_shell_callback;

              local post_shell_callback = args.post_shell_callback or function(bufnr)
                  local filetype = vim.api.nvim_buf_get_option(bufnr, 'filetype');

                  for name, func in pairs(args.language_servers) do
                      if vim.tbl_contains(vim.lsp.config[name].filetypes, filetype) then
                          func(function(opts)
                              local final_opts = vim.tbl_deep_extend(
                                  'force',
                                  vim.lsp.config[name],
                                  {
                                      capabilities = default_capabilities,
                                  }
                              );

                              local has_root_dir_callback = vim.lsp.config[name]['root_dir'] ~= nil and type(vim.lsp.config[name]['root_dir']) == 'function';

                              if not has_root_dir_callback and vim.lsp.config[name]['root_markers'] ~= nil then
                                  final_opts = vim.tbl_deep_extend('force', final_opts, {
                                      root_dir = vim.fs.root(
                                          0,
                                          vim.lsp.config[name]['root_markers']
                                      ),
                                  });
                              end;

                              if has_root_dir_callback then
                                  vim.lsp.config[name]['root_dir'](0, function(root_dir)
                                      vim.lsp.start(vim.tbl_deep_extend('force', final_opts, {
                                          root_dir = root_dir,
                                      }, opts or {}), { bufnr = bufnr });
                                  end);
                              else
                                  vim.lsp.start(vim.tbl_deep_extend('force', final_opts, opts or {}), { bufnr = bufnr });
                              end;
                          end);
                      end;
                  end;
              end;

              vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
                  pattern = pattern,

                  callback = function(args)
                      local bufnr = args.buf;

                      vim.schedule(pre_shell_callback);

                      local final_post_shell_callback = function()
                          post_shell_callback(bufnr);
                      end;

                      if (devShells[name] == nil) then
                          devShells[name] = 1;

                          nix_develop.nix_develop_extend(
                              { '${flakeEnv}#' .. name },
                              final_post_shell_callback
                          );
                      else
                          print('Shell already extended. Launching Language Servers');
                          vim.schedule(final_post_shell_callback);
                      end
                  end,
              });
          end;

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
          name = "vimplugin-${o.pname}-${mkVersion vimplugin-nix-develop-src}";
          src = vimplugin-nix-develop-src;
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
              --
              require('nvim-autopairs').setup({});
            '';
        };

        tiny-inline-diagnostic = {
          plugin = pkgs.vimPlugins.tiny-inline-diagnostic-nvim;
          type = "lua";
          config =
            # lua
            ''
              --
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
