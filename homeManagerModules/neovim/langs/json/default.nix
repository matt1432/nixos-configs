{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.neovim;
  flakeEnv = config.programs.bash.sessionVariables.FLAKE;
in {
  config = mkIf cfg.enable {
    programs = {
      neovim = {
        extraLuaConfig =
          # lua
          ''
            vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
                pattern = { 'json', 'yaml', '.clang-.*' },

                callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];

                    if (devShells['json'] == nil) then
                        devShells['json'] = 1;

                        require('nix-develop').nix_develop_extend({'${flakeEnv}#json'}, function()
                            vim.cmd[[LspStart]];
                        end);
                    end
                end,
            });

            local lsp = require('lspconfig');
            local default_capabilities = require('cmp_nvim_lsp').default_capabilities();

            lsp.jsonls.setup({
                capabilities = default_capabilities,
                autostart = false,
            });

            lsp.yamlls.setup({
                capabilities = default_capabilities,
                autostart = false,

                settings = {
                    yaml = {
                        format = {
                            enable = true,
                            singleQuote = true,
                        },
                        schemas = {
                            [
                                "https://json.schemastore.org/github-workflow.json"
                            ] = "/.github/workflows/*",
                        },
                    },
                },
            });
          '';
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
