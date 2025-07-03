pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:b792fa40960b59056e4d6dbf1386cacada2706c2ec5625882cb1c9d60dbf2437";
  hash = "sha256-pqQ58p8Rrk12Fd9N9ImPXZiCwlG9L6Bl36AVU/nYq9w=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
