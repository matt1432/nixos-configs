pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:594fab7afdb1de2f61a82835f3f2377a6220d4940d4b49bfa95e82d8a6b13a95";
  sha256 = "08marxpgx249db5nc23qq40vpynygs7nx0vg0dmhgyv4jkvn4cb9";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
