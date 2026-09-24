{
  lib,
  mainUser,
  pkgs,
  ...
}: let
  inherit (lib) attrValues mkForce;

  dotnet-combined = with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_8_0
      sdk_10_0-bin
    ];
in {
  environment = {
    variables = {
      DOTNET_ROOT = "${dotnet-combined}/share/dotnet";
      TF_VAR_env = "dev";
      TF_VAR_suffix = "-mh";
      AWS_SDK_LOAD_CONFIG = "1";
      BROWSER = "/home/${mainUser}/.local/bin/firefox";
    };

    systemPackages = attrValues {
      inherit (pkgs) awscli2 openssl_4_0 tfenv xdg-utils;

      inherit dotnet-combined;

      # https://github.com/npm/promise-spawn/blob/e19bfab86f4370eb52911032cae8e4d887e6cd1f/lib/index.js#L159
      sensible-browser = pkgs.writeShellApplication {
        name = "sensible-browser";
        text = ''
          exec "$BROWSER" "$@"
        '';
      };

      loginNPM = pkgs.writeShellApplication {
        name = "loginNPM";
        text = ''
          npm login --registry=https://registry.npmjs.org/ --scope=landr --auth-type=web
          npm login --registry=https://registry.yarnpkg.com/ --scope=landr --auth-type=web
        '';
      };
    };
  };

  home-manager.users.${mainUser} = {
    imports = [
      ({config, ...}: let
        inherit (config.lib.file) mkOutOfStoreSymlink;
      in {
        home.sessionPath = ["$HOME/.dotnet/tools"];

        programs.bash.bashrcExtra = ''
          source ~/.landr.sh
        '';

        home.file.".local/bin/firefox".source = mkOutOfStoreSymlink "/mnt/c/Program Files/Firefox Developer Edition/firefox.exe";

        home.file.".docker/config.json".text = mkForce ''
          {
            "psFormat": "table {{.ID}}\\t{{.Image}}\\t{{.Names}}\\t{{.Status}}",
            "auths":{"714500182046.dkr.ecr.us-east-1.amazonaws.com":{}},
            "credsStore":"wincred.exe"
          }
        '';
      })
    ];
  };
}
