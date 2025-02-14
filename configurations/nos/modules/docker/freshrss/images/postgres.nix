pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:5d8330e221083215ffbb3c5feeb2cfe44aadda827bc3f0dad9bbf3e58ed2e895";
  hash = "sha256-7dttITmG8h+TWS4xLDDQMxL9NuMLkL2LDn/jhZGogSk=";
  finalImageName = imageName;
  finalImageTag = "14";
}
