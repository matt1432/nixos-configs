pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:a10d94a66b54467bac5ca725f5a50d7212ec2f6f994c844d6936de879d969a57";
  hash = "sha256-Ars/oeL/vSxOMYN47+cA1jgzpo3Sbl+6cgIIbX6ZJfU=";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
