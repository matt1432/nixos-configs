{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.programs.neovim;
in {
  config = mkIf cfg.enable {
    programs = {
      neovim = {
        initLua =
          # lua
          ''
            --
            loadDevShell({
                name = 'json',
                pattern = { 'json', 'yaml', '.clang-.*' },
                pre_shell_callback = function()
                    vim.cmd[[setlocal ts=4 sw=4 sts=0 expandtab]];
                end,
                language_servers = {
                    jsonls = function(start)
                        start();
                    end,

                    yamlls = function(start)
                        start({
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
                    end,
                },
            });
          '';
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
