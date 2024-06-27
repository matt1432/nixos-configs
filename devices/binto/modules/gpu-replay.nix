{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  inherit (lib) concatStringsSep removePrefix;

  inherit (config.vars) mainUser;

  cfgDesktop = config.roles.desktop;

  gsr = self.packages.${pkgs.system}.gpu-screen-recorder;
  hyprPkgs = config.home-manager.users.${mainUser}.wayland.windowManager.hyprland.finalPackage;
in {
  security.wrappers = {
    gpu-screen-recorder = {
      owner = "root";
      group = "video";
      capabilities = "cap_sys_nice+ep";
      source = "${gsr}/bin/gpu-screen-recorder";
    };

    gsr-kms-server = {
      owner = "root";
      group = "video";
      capabilities = "cap_sys_admin+ep";
      source = "${gsr}/bin/gsr-kms-server";
    };
  };

  home-manager.users.${mainUser} = {
    home.packages = [
      gsr

      (pkgs.writeShellApplication {
        name = "gpu-save-replay";
        runtimeInputs = [pkgs.procps];
        text = ''
          pkill --signal SIGUSR1 -f gpu-screen-recorder
        '';
      })

      (pkgs.writeShellApplication {
        name = "gsr-start";
        runtimeInputs = [pkgs.pulseaudio hyprPkgs pkgs.xorg.xrandr];
        text = ''
          main="${removePrefix "desc:" cfgDesktop.mainMonitor}"
          WINDOW=$(hyprctl -j monitors | jq '.[] |= (.description |= gsub(","; ""))' | jq -r ".[] | select(.description | test(\"$main\")) | .name")

          # Fix fullscreen game resolution
          xrandr --output "$WINDOW" --primary

          gpu-screen-recorder ${concatStringsSep " " [
            ''-v no''
            ''-r 1200''
            ''-mf yes''
            ''-o /home/matt/Videos/Replay''
            # Audio settings
            ''-ac aac''
            ''-a "$(pactl get-default-sink).monitor"''
            ''-a "$(pactl get-default-source)"''
            # Video settings
            ''-w "$WINDOW"''
            ''-f 60''
            ''-c mkv''
            ''-k hevc''
            ''-q very_high''
          ]}
        '';
      })
    ];

    wayland.windowManager.hyprland.settings = {
      bind = [",F8, exec, ags -r 'GSR.saveReplay()'"];
    };
  };
}
