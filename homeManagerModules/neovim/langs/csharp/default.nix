self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (self.lib.${pkgs.system}) buildPlugin;
  inherit (self.inputs) vimplugin-roslyn-nvim-src;

  inherit (lib) mkIf;

  cfg = config.programs.neovim;
  flakeEnv = config.programs.bash.sessionVariables.FLAKE;
in {
  config = mkIf cfg.enable {
    programs = {
      neovim = {
        plugins = [
          {
            plugin = buildPlugin "roslyn-nvim" vimplugin-roslyn-nvim-src;
            type = "lua";
            config =
              # lua
              ''
                vim.api.nvim_create_autocmd('User', {
                    pattern = 'RoslynInitialized',

                    callback = function()
                        vim.lsp.inlay_hint.enable();
                    end,
                });

                local startRoslyn = function()
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
                end;

                vim.api.nvim_create_autocmd('FileType', {
                    pattern = { 'cs' },

                    callback = function()
                        vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];

                        if (devShells['csharp'] == nil) then
                            devShells['csharp'] = 1;

                            require('nix-develop').nix_develop({'${flakeEnv}#csharp'});
                            startRoslyn();

                            os.execute('sleep 1')
                            vim.cmd[[e]]; -- reload to attach on current file
                        end
                    end,
                });
              '';
          }
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
