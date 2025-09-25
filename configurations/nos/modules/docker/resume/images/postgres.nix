pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:5e50b90b3b7dd846bc66e5bdf7a9f408ee9a79c3fc4b2f60294f64c310a7df1e";
  hash = "sha256-CJji1I7cfsJSEu/omcrDTQDTlbxQlafFeGq3WM5FfV0=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
