self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkIf;
  inherit (self.lib.${pkgs.system}) buildPlugin;
  inherit (self.inputs) vimplugin-roslyn-nvim-src;

  cfg = config.programs.neovim;
in {
  config = mkIf cfg.enable {
    programs = {
      neovim = {
        extraPackages = attrValues {
          inherit
            (pkgs)
            roslyn-ls
            ;
        };

        extraLuaConfig =
          # lua
          ''
            vim.api.nvim_create_autocmd('FileType', {
                pattern = { 'cs' },
                command = 'setlocal ts=4 sw=4 sts=0 expandtab',
            });

            vim.api.nvim_create_autocmd('User', {
                pattern = 'RoslynInitialized',
                callback = function()
                    vim.lsp.inlay_hint.enable();
                end,
            });

            require('roslyn').setup({
                config = {
                    capabilities = require('cmp_nvim_lsp').default_capabilities(),

                    on_attach = function()
                        vim.lsp.inlay_hint.enable();
                    end,

                    settings = {
                        ["csharp|inlay_hints"] = {
                            csharp_enable_inlay_hints_for_implicit_object_creation = true,
                            csharp_enable_inlay_hints_for_implicit_variable_types = true,
                            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
                            csharp_enable_inlay_hints_for_types = true,
                            dotnet_enable_inlay_hints_for_indexer_parameters = true,
                            dotnet_enable_inlay_hints_for_literal_parameters = true,
                            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
                            dotnet_enable_inlay_hints_for_other_parameters = true,
                            dotnet_enable_inlay_hints_for_parameters = true,
                            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
                            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
                            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
                        },
                    },
                },

                exe = 'Microsoft.CodeAnalysis.LanguageServer',
            });
          '';

        plugins = [
          (buildPlugin "roslyn-nvim" vimplugin-roslyn-nvim-src)
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
