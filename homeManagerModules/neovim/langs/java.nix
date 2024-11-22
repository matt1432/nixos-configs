{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe mkIf;

  cfg = config.programs.neovim;

  javaSdk = pkgs.temurin-bin-17;
  javaPkgs = builtins.attrValues {inherit (pkgs) gradle maven;};
in
  mkIf cfg.enableIde {
    home.packages = javaPkgs;

    xdg.dataFile.".gradle/gradle.properties".text = ''
      org.gradle.java.home = ${javaSdk}
    '';

    programs = {
      java = {
        enable = true;
        package = javaSdk;
      };

      neovim = {
        extraPackages = javaPkgs;

        extraLuaConfig =
          # lua
          ''
            vim.api.nvim_create_autocmd('FileType', {
               pattern = 'java',
               command = 'setlocal ts=4 sw=4 sts=0 expandtab',
            });
          '';

        plugins = [
          {
            # TOOD: setup debugger https://github.com/mfussenegger/nvim-jdtls#debugger-via-nvim-dap
            plugin = pkgs.vimPlugins.nvim-jdtls;
            type = "lua";
            config =
              # lua
              ''
                --
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
                                            name = 'JavaSE-17',
                                            path = '${javaSdk}',
                                        },
                                    },
                                },
                            },
                        },
                    };

                    require('jdtls').start_or_attach(config);
                end

                vim.api.nvim_create_autocmd('FileType', {
                    pattern = 'java',
                    callback = startJdtls,
                });
              '';
          }
        ];
      };
    };
  }
