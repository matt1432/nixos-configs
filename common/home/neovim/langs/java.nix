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
          /*
          lua
          */
          ''
            vim.api.nvim_create_autocmd("FileType", {
               pattern = 'java',
               command = 'setlocal ts=4 sw=4 sts=0 expandtab',
            });
          '';

        coc.settings.java = {
          maven.downloadSources = true;
          eclipse.downloadSources = true;

          format.settings.url = "eclipse-formatter.xml";

          jdt.ls = {
            java.home = "${javaSdk}";
            statusIcons = {
              "busy" = "Busy";
              "ready" = "OK";
              "warning" = "Warning";
              "error" = "Error";
            };
          };
        };

        plugins = [
          vimPlugins.coc-java
        ];
      };
    };
  }
