pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:a848b8a1d9e3b2553157ceb72cd3fc6ae2b34e71bcece24561b0944fb7922b46";
  hash = "sha256-WfO0/MeDBsl6yZKlvgvysLjAaqe1PMVhQXjGOueqyq4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
