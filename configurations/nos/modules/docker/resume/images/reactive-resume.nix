pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:0fc95577f55986331ffeef3a29d5c8dfa7159a50d0f9a0abc676c27b8f3f0c04";
  hash = "sha256-ruQc5kjiKIdVBNGyw5Fc3z7HezhypL0cyfdcp8t6CsQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
