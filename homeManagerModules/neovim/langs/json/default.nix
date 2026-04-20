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
            LoadDevShell({
                name = "json",
                pattern = { "json", "yaml", ".clang-.*", "%.json$", "%.jsonc$" },
                pre_shell_callback = function(bufnr)
                    vim.bo[bufnr].ts = 4;
                    vim.bo[bufnr].sw = 4;
                    vim.bo[bufnr].sts = 0;
                    vim.bo[bufnr].expandtab = true;
                end,
                language_servers = {
                    jsonls = function(start)
                        start()

                        vim.bo[0].ts = 4;
                        vim.bo[0].sw = 4;
                        vim.bo[0].sts = 0;
                        vim.bo[0].expandtab = true;
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
                                        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                                    },
                                },
                            },
                        })
                    end,
                },
            })
          '';
      };
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
