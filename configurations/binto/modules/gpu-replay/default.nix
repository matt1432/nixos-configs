{
  config,
  lib,
  mainUser,
  pkgs,
  ...
}: let
  inherit (lib) concatStringsSep getExe hasPrefix removePrefix;
  inherit (pkgs.selfPackages) gpu-screen-recorder;

  hyprPkgs = config.home-manager.users.${mainUser}.wayland.windowManager.hyprland.finalPackage;

  cfgDesktop = config.roles.desktop;

  recordedWindow =
    if hasPrefix "desc:" cfgDesktop.mainMonitor
    then
      # bash
      ''$(hyprctl -j monitors | jq '.[] |= (.description |= gsub(","; ""))' | jq -r ".[] | select(.description | test(\"${removePrefix "desc:" cfgDesktop.mainMonitor}\")) | .name")''
    else cfgDesktop.mainMonitor;
in {
  security.wrappers = {
    gsr-kms-server = {
      owner = "root";
      group = "video";
      capabilities = "cap_sys_admin+ep";
      source = getExe gpu-screen-recorder.gsr-kms-server;
    };
  };

  home-manager.users.${mainUser} = {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "gpu-save-replay";

        runtimeInputs = with pkgs; [procps];

        text = ''
          pkill --signal SIGUSR1 -f gpu-screen-recorder
        '';
      })

      (pkgs.writeShellApplication {
        name = "gsr-start";

        runtimeInputs = [
          pkgs.pulseaudio
          pkgs.xorg.xrandr

          gpu-screen-recorder
          gpu-screen-recorder.gsr-dbus-server
          hyprPkgs
        ];

        text = ''
          WINDOW=${recordedWindow}

          # Fix fullscreen game resolution
          xrandr --output "$WINDOW" --primary

          exec gpu-screen-recorder ${concatStringsSep " " [
            # Prints fps and damage info once per second.
            "-v no"

            # Replay buffer time in seconds.
            "-r 1200"

            # Organise replays in folders based on the current date.
            "-df yes"
            "-o /home/matt/Videos/Replay"

            # Audio codec to use.
            "-ac aac"

            # Audio device or application to record from (pulse audio device).
            "-a default_output"
            "-a default_input"

            # Window id to record, display (monitor name), "screen", "screen-direct", "focused" or "portal".
            "-w \"$WINDOW\""

            # Frame rate to record at.
            "-f 60"

            # Container format for output file.
            "-c mkv"

            # Video codec to use.
            "-k hevc"
          ]}
        '';
      })
    ];

    wayland.windowManager.hyprland.settings = {
      bind = [",F8, exec, ags request 'save-replay'"];
    };
  };
}
