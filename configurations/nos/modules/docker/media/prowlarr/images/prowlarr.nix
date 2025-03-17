pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:18e9801e4509e45873c1adb03adf0bf718743ff5147e19b4cdf7626f8bd2f752";
  hash = "sha256-SXlE7QYGGVWePjORCFiN+0bfqFpEfoPV0fp5XqN9XCU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
