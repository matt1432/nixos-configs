pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:b0c387456c059ead0d4cf76861d633c66b34a6b888ec5834d353951f1bde1384";
  sha256 = "1xaq1m8kcxvvi082lf8p6j48niqbivq61ddm3hilw4sjp9phq2a5";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
