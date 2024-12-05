pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:2e37ae0af799e01f413a97ee82c7e581a5b635816df0380889bc65d554dbeb17";
  sha256 = "1mf15859pz3jdkczhh7phi80d7acajlx3855krigjspb5r8jmsm2";
  finalImageName = imageName;
  finalImageTag = "latest";
}
