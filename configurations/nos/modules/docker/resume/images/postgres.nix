pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:5402d0a13eab398c7c38f1b90af081d7f9e5977606ed869cecdb661403f6586a";
  hash = "sha256-jxlKKWWubnN2AskHltA73d19IMCdaJgWJsq0fItPUBA=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
