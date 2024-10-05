{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.vars) neovimIde;
in
  mkIf neovimIde {
    programs = {
      neovim = {
        extraPackages = builtins.attrValues {
          inherit
            (pkgs)
            csharp-ls
            ;
        };

        extraLuaConfig =
          # lua
          ''
            vim.api.nvim_create_autocmd('FileType', {
                pattern = {'cs'},
                command = 'setlocal ts=4 sw=4 sts=0 expandtab',
            });

            local csharpls_extended = require('csharpls_extended');

            require('lspconfig').csharp_ls.setup({
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
                handlers = {
                    ["textDocument/definition"] = csharpls_extended.handler,
                    ["textDocument/typeDefinition"] = csharpls_extended.handler,
                },
            });
          '';

        plugins = builtins.attrValues {
          inherit (pkgs.vimPlugins) csharpls-extended-lsp-nvim;
        };
      };
    };
  }
