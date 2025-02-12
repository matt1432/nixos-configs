pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:88272d031e268a5d10035e2707fc095417dba9794a7a4a59b51f01e6f9b74f65";
  hash = "sha256-ZXJBPazcwnwG1sAtuwLR8O1IDOXQOl8DbsYz3I1+p1Q=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
