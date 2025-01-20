self: {
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.roles.desktop;
  agsCfg = hmCfg.programs.ags;
  hmCfg = config.home-manager.users.${cfg.user};

  hyprland = hmCfg.wayland.windowManager.hyprland.finalPackage;

  agsConfig = let
    homeFiles = config.home-manager.users.${cfg.user}.home.file;

    nodeModules = homeFiles."${agsCfg.configDir}/node_modules".source;
    varsTs = homeFiles."${agsCfg.configDir}/widgets/lockscreen/vars.ts".source;
  in
    pkgs.runCommandLocal "agsConfig" {} ''
      cp -ar ${../../../ags/config}/* ./.
      chmod +w -R ./.
      cp -ar ${varsTs} ./widgets/lockscreen/vars.ts
      cp -ar ${nodeModules} ./node_modules
      ${agsCfg.package}/bin/ags bundle ./app.ts $out
    '';
in {
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.ags.enable;
        message = ''
          The Display Manager requires AGS to be enabled.
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
            agsCfg.package
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
