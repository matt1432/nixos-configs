pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:6bd113a3de3274beda0f056ebf0d75cf060dc4a493b72bea6f9d810dce63f897";
  hash = "sha256-jcwdiotvsy1d3E0TCbJlcMxFY3fxu6/qTXCiSMnyZwU=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
