pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:4b8d6111bd6708e27741ce427b1a200a2203977187e6a76e9a5b494f43bfeb74";
  sha256 = "1jz8xhyxmi4fgb85wmc4zs5wf5wq3pggwgg4y0jihh4k3cpr2qf3";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
