{
  pkgs,
  config,
  lib,
  ...
}: let
  gsr = pkgs.gpu-screen-recorder.overrideAttrs (o: {
    src = pkgs.fetchurl {
      url = "https://dec05eba.com/snapshot/gpu-screen-recorder.git.r444.02ee8b8.tar.gz";
      hash = "sha256-RkHg2OpgaFrKhLa+sa6IMt0j/3wZ6OehSKmD/M63S5Q=";
    };

    postPatch = "";

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
  });
in {
  environment.systemPackages = with pkgs; [
    pulseaudio # for getting audio sink
    gsr

    (writeShellScriptBin "gpu-save-replay" ''
      exec ${pkgs.procps}/bin/pkill --signal SIGUSR1 -f gpu-screen-recorder
    '')
  ];

  # Allow CUDA on boot
  boot.kernelModules = ["nvidia-uvm"];

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

  home-manager.users.${config.vars.user} = {
    # TODO: add mic sound
    xdg.configFile."gsr.sh" = {
      executable = true;
      text = ''
        export WINDOW=DP-5
        export CONTAINER=mkv
        export QUALITY=very_high
        export CODEC=auto
        export AUDIO_CODEC=aac
        export FRAMERATE=60
        export REPLAYDURATION=1200
        export OUTPUTDIR=/home/matt/Videos/Replay
        export MAKEFOLDERS=yes
        # export ADDITIONAL_ARGS=

        # Disable compositor in X11 for best performance
        exec /bin/sh -c 'AUDIO="''${AUDIO_DEVICE:-$(pactl get-default-sink).monitor}"; gpu-screen-recorder -v no -w $WINDOW -c $CONTAINER -q $QUALITY -k $CODEC -ac $AUDIO_CODEC -a "$AUDIO" -f $FRAMERATE -r $REPLAYDURATION -o "$OUTPUTDIR" -mf $MAKEFOLDERS $ADDITIONAL_ARGS'
      '';
    };
  };
}
