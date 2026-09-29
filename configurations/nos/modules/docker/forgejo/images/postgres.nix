pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:c2427de38f998489d36de7ca3553db2134872c400f2b08be4b824e5c50e4d619";
  hash = "sha256-joyvYK1DoMzrtDwz7FlXO9dNTNey5z8+sCqocTsucCA=";
  finalImageName = imageName;
  finalImageTag = "14";
}
