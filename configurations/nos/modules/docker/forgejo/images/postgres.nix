pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:eba8ddbdd837ecfbb6ca8a26d8deec68a2f9b076660102ae641dba0f371c099b";
  hash = "sha256-vaxCKt1pwfXqYNshC/9u6Hz7D3rE/aOEJWDTEZ4+0m4=";
  finalImageName = imageName;
  finalImageTag = "14";
}
