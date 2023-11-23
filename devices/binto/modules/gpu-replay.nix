{
  pkgs,
  lib,
  ...
}: let
  gsr = pkgs.gpu-screen-recorder.overrideAttrs (o: {
    src = pkgs.fetchgit {
      url = "https://repo.dec05eba.com/gpu-screen-recorder";
      rev = "2f60f4c109f1bcc748d5f0d937476e8708a4073b";
      hash = "sha256-pdyKspXx6ozXLgfLHAyRrPVJ2kzllHQDhPu1QQwpQjU=";
    };

    buildInputs =
      (o.buildInputs or [])
      ++ (with pkgs; [
        wayland
        wayland-protocols
        libdrm
        libva
        xorg.libXrandr
        libglvnd
      ]);

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
}
