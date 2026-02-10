self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.roles.desktop;
  hmCfg = config.home-manager.users.${cfg.user};

  hyprland = hmCfg.wayland.windowManager.hyprland.finalPackage;
  agsPkg = pkgs.ags.override {
    extraPackages = builtins.attrValues {
      inherit
        (pkgs.astal)
        io
        astal3
        astal4
        apps
        auth
        battery
        bluetooth
        greet
        hyprland
        mpris
        network
        notifd
        powerprofiles
        tray
        wireplumber
        ;

      # libkompass dependencies
      inherit
        (pkgs.astal)
        cava
        river
        ;

      inherit
        (pkgs)
        libadwaita
        networkmanager
        gtk4-layer-shell
        gtk4 # Needed to build types
        ;
    };
  };

  agsConfig = let
    inherit
      (self.lib.${pkgs.stdenv.hostPlatform.system})
      buildNodeModules
      ;

    nodeModules = buildNodeModules ../../../ags/config (import ../../../ags/config).npmDepsHash;
  in
    pkgs.runCommandLocal "agsConfig" {} ''
      cp -ar ${../../../ags/config}/* ./.
      chmod +w -R ./.
      cp -ar ${nodeModules} ./node_modules
      ${agsPkg}/bin/ags bundle ./app.ts $out
    '';
in {
  config = mkIf cfg.enable {
    # Add home folder for home-manager to work
    users.users.greeter = {
      home = "/var/lib/greeter";
      createHome = true;
    };

    home-manager.users.greeter = {
      home.file."agsGreeter".source = agsConfig;
      home.packages = [
        hyprland

        (pkgs.writeShellApplication {
          name = "agsGreeter";

          runtimeInputs = [
            agsPkg
            hyprland
          ];

          text = ''
            exec ags run ${agsConfig} -a greeter
          '';
        })
      ];
    };
  };

  # For accurate stack trace
  _file = ./default.nix;
}
