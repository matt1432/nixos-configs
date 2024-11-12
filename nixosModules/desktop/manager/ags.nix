self: {
  config,
  lib,
  pkgs,
  ...
}: {
  config = let
    # Libs
    inherit (lib) removePrefix;

    cfg = config.roles.desktop;
    hmCfg = config.home-manager.users.${cfg.user};

    ags = hmCfg.programs.ags-v2.package;
    hyprland = hmCfg.wayland.windowManager.hyprland.finalPackage;

    agsConfig = let
      homeFiles = config.home-manager.users.${cfg.user}.home.file;
      agsDir = "${removePrefix "/home/${cfg.user}/" config.environment.variables.FLAKE}/nixosModules/ags-v2/config";

      nodeModules = homeFiles."${agsDir}/node_modules".source;
      tsconfig = homeFiles."${agsDir}/tsconfig.json".source;
      varsTs = homeFiles."${agsDir}/widgets/lockscreen/vars.ts".source;
    in
      pkgs.runCommandLocal "agsConfig" {} ''
        cp -ar ${tsconfig} ./tsconfig.json
        cp -ar ${../../ags-v2/config}/* ./.
        chmod +w -R ./.
        cp -ar ${varsTs} ./widgets/lockscreen/vars.ts
        cp -ar ${nodeModules} ./node_modules
        ${ags}/bin/ags bundle ./app.ts $out
      '';
  in {
    assertions = [
      {
        assertion = cfg.ags-v2.enable;
        message = ''
          The Display Manager requires AGSv2 to be enabled.
        '';
      }
    ];

    # Add home folder for home-manager to work
    users.users.greeter = {
      home = "/var/lib/greeter";
      createHome = true;
    };

    home-manager.users.greeter = {
      home.packages = [
        hyprland

        (pkgs.writeShellApplication {
          name = "agsGreeter";

          runtimeInputs = [
            ags
            hyprland
          ];

          text = ''
            export CONF="greeter"
            exec ags run ${agsConfig}
          '';
        })
      ];
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
