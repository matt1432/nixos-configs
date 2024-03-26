{
  pkgs,
  config,
  lib,
  gpu-screen-recorder-src,
  ...
}: let
  inherit (config.vars) mainUser mainMonitor;
  inherit (lib) concatStringsSep removePrefix;
  hyprPkgs = config.home-manager.users.${mainUser}.wayland.windowManager.hyprland.finalPackage;

  gsr = pkgs.stdenv.mkDerivation {
    name = "gpu-screen-recorder";
    version = gpu-screen-recorder-src.shortRev;

    src = gpu-screen-recorder-src;

    nativeBuildInputs = with pkgs; [
      pkg-config
      makeWrapper
    ];

    buildInputs = with pkgs; [
      libpulseaudio
      ffmpeg
      wayland
      libdrm
      libva
      xorg.libXcomposite
      xorg.libXrandr
    ];

    buildPhase = ''
      ./build.sh
    '';

    installPhase = ''
      strip gsr-kms-server
      strip gpu-screen-recorder

      install -Dm755 "gsr-kms-server" "$out/bin/gsr-kms-server"
      install -Dm755 "gpu-screen-recorder" "$out/bin/gpu-screen-recorder"
      #install -Dm644 "extra/gpu-screen-recorder.service" "$out/lib/systemd/user/gpu-screen-recorder.service"

      wrapProgram $out/bin/gpu-screen-recorder --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [
        pkgs.addOpenGLRunpath.driverLink
        pkgs.libglvnd
      ]}"
    '';
  };
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
    home.packages = with pkgs; [
      gsr

      (writeShellApplication {
        name = "gpu-save-replay";
        runtimeInputs = [procps];
        text = ''
          pkill --signal SIGUSR1 -f gpu-screen-recorder
        '';
      })

      (writeShellApplication {
        name = "gsr-start";
        runtimeInputs = [pulseaudio hyprPkgs xorg.xrandr];
        text = ''
          main="${removePrefix "desc:" mainMonitor}"
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
