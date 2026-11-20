pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "docker";
  imageDigest = "sha256:4bbc7223f81db790097c6dea42fb93e05b8fead4f0431fbe6ccaba6e8473201c";
  hash = "sha256-UeHR3P14yAZ1/41vvqxASOxyW2CkLcpEsv5LLMQ1pjc=";
  finalImageName = imageName;
  finalImageTag = "dind";
}
