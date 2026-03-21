pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:705a5d5b5836f3fcba0d02c4d281e6a7dd9ed2dd4078640f08a1e1e9896e097d";
  hash = "sha256-PBgDw5NznvqfwouJbyyl1sa1YRRTDDLMl/9dLqrZ2ko=";
  finalImageName = imageName;
  finalImageTag = "14";
}
