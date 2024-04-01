pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:122cb0e9104f5b29b48a2578e0ad02ad82c8b8568b8bc5154eb6e360f4e72799";
  sha256 = "0a0qi31l8wff86srs7v46ljfrsslkqdzarnvn20gy6av54ga4yid";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
