{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkIf;

  cfg = config.programs.neovim;
in
  mkIf cfg.enableIde {
    programs = {
      neovim = {
        extraPackages = attrValues {
          inherit
            (pkgs)
            omnisharp-roslyn
            ;
        };

        extraLuaConfig =
          # lua
          ''
            vim.api.nvim_create_autocmd('FileType', {
                pattern = { 'cs' },
                command = 'setlocal ts=4 sw=4 sts=0 expandtab',
            });

            local omnisharp_extended = require('omnisharp_extended');

            require('lspconfig').omnisharp.setup({
                cmd = { 'dotnet', '${pkgs.omnisharp-roslyn}/lib/omnisharp-roslyn/OmniSharp.dll' },

                handlers = {
                    ['textDocument/definition'] = omnisharp_extended.definition_handler,
                    ['textDocument/typeDefinition'] = omnisharp_extended.type_definition_handler,
                    ['textDocument/references'] = omnisharp_extended.references_handler,
                    ['textDocument/implementation'] = omnisharp_extended.implementation_handler,
                },

                settings = {
                    FormattingOptions = {
                        EnableEditorConfigSupport = true,
                        OrganizeImports = true,
                    },
                    MsBuild = {
                        LoadProjectsOnDemand = false,
                    },
                    RoslynExtensionsOptions = {
                        EnableAnalyzersSupport = true,
                        EnableDecompilationSupport = true,
                        EnableImportCompletion = true,
                        AnalyzeOpenDocumentsOnly = false,
                    },
                    Sdk = {
                        IncludePrereleases = true,
                    },
                },
            });
          '';

        plugins = attrValues {
          inherit
            (pkgs.vimPlugins)
            omnisharp-extended-lsp-nvim
            ;
        };
      };
    };
  }
