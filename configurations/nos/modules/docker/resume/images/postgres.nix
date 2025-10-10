pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:a7adf8c3e57aa26b15941497eaf98065f5930e2db6df8f7dc7dd61aee44347cb";
  hash = "sha256-jcwdiotvsy1d3E0TCbJlcMxFY3fxu6/qTXCiSMnyZwU=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
