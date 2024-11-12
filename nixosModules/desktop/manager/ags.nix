self: {
  config,
  lib,
  pkgs,
  ...
}: let
  # TODO: clean this up
  inherit (self.inputs) agsV2 gtk-session-lock;
in {
  config = let
    # Libs
    inherit (lib) attrValues boolToString removeAttrs;

    # Cfg info
    inherit (config.networking) hostName;
    cfgDesktop = config.roles.desktop;

    # Astal libraries
    gtkSessionLock = gtk-session-lock.packages.${pkgs.system}.default;
    agsV2Packages = agsV2.packages.${pkgs.system};
    astalLibs = attrValues (removeAttrs agsV2.inputs.astal.packages.${pkgs.system} ["docs" "gjs"]) ++ [gtkSessionLock];

    # Final ags package
    agsFull = agsV2Packages.ags.override {extraPackages = astalLibs;};

    agsConfig = let
      tsconfig = pkgs.writers.writeJSON "tsconfig.json" {
        "$schema" = "https://json.schemastore.org/tsconfig";
        "compilerOptions" = {
          "experimentalDecorators" = true;
          "strict" = true;
          "target" = "ES2023";
          "moduleResolution" = "Bundler";
          "jsx" = "react-jsx";
          "jsxImportSource" = "${agsV2Packages.gjs}/share/astal/gjs/gtk3";
          "paths" = {
            "astal" = ["${agsV2Packages.gjs}/share/astal/gjs"];
            "astal/*" = ["${agsV2Packages.gjs}/share/astal/gjs/*"];
          };
          "skipLibCheck" = true;
          "module" = "ES2022";
          "lib" = ["ES2023"];
        };
      };

      varsTs =
        pkgs.writeText "vars.ts"
        # javascript
        ''
          export default {
              mainMonitor: '${cfgDesktop.mainMonitor}',
              dupeLockscreen: ${boolToString cfgDesktop.displayManager.duplicateScreen},
              hasFprintd: ${boolToString (hostName == "wim")},
          };
        '';

      flakeDir = config.environment.variables.FLAKE;
      modulesDir = "${lib.removePrefix "/home/${cfg.user}/" flakeDir}/nixosModules";
      nodeModules = config.home-manager.users.${cfg.user}.home.file."${modulesDir}/ags/config/node_modules".source
        or config.home-manager.users.${cfg.user}.home.file."${modulesDir}/ags-v2/config/node_modules".source;
    in
      pkgs.runCommandLocal "agsConfig" {} ''
        cp -ar ${tsconfig} ./tsconfig.json
        cp -ar ${../../ags-v2/config}/* ./.
        chmod +w -R ./.
        cp -ar ${varsTs} ./widgets/lockscreen/vars.ts
        cp -ar ${nodeModules} ./node_modules
        ${agsFull}/bin/ags bundle ./app.ts $out
      '';

    cfg = config.roles.desktop;

    hyprland =
      config
      .home-manager
      .users
      .${cfg.user}
      .wayland
      .windowManager
      .hyprland
      .finalPackage;
  in {
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
            agsFull
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
