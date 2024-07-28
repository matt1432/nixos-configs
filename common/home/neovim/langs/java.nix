{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (pkgs) vimPlugins;
  inherit (config.vars) neovimIde;

  javaSdk = pkgs.temurin-bin-17;
  javaPkgs = with pkgs; [gradle maven];
in
  lib.mkIf neovimIde {
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
            plugin = vimPlugins.nvim-jdtls;
            type = "lua";
            config =
              # lua
              ''
                --
                local startJdtls = function()
                    local config = {
                        capabilities = require('cmp_nvim_lsp').default_capabilities(),

                        cmd = { '${lib.getExe pkgs.jdt-language-server}' },
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
