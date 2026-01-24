{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe mkIf;

  cfg = config.programs.neovim;

  javaSdk = pkgs.temurin-bin-21;
in {
  config = mkIf (cfg.enable && cfg.ideConfig.enableJava) {
    programs = {
      # We keep the packages here because java is a bit complicated
      java = {
        enable = true;
        package = javaSdk;
      };

      neovim = {
        initLua =
          # lua
          ''
            vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
               pattern = 'java',
               command = 'setlocal ts=4 sw=4 sts=0 expandtab',
            });
          '';

        plugins = [
          {
            # TOOD: setup debugger https://github.com/mfussenegger/nvim-jdtls#debugger-via-nvim-dap
            plugin = pkgs.vimPlugins.nvim-jdtls;
            type = "lua";
            config = ''
              local startJdtls = function()
                  local config = {
                      capabilities = require('cmp_nvim_lsp').default_capabilities(),

                      cmd = { '${getExe pkgs.jdt-language-server}' },
                      root_dir = vim.fs.dirname(vim.fs.find(
                          { 'gradlew', '.git', 'mvnw', 'pom.xml' },
                          { upward = true }
                      )[1]),

                      settings = {
                          java = {
                              configuration = {
                                  runtimes = {
                                      {
                                          name = 'JavaSE-21',
                                          path = '${javaSdk}',
                                      },
                                  },
                              },
                          },
                      },
                  };

                  require('jdtls').start_or_attach(config);
              end;

              vim.api.nvim_create_autocmd({ 'FileType', 'BufEnter' }, {
                  pattern = 'java',
                  callback = startJdtls,
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
