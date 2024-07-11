pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:cd0e0de27454b040a0d55d1a06885dc78366435ce6794b82a6e4194b795e213a";
  sha256 = "0gl8z845aih0kdqabdhhf8fvbldx121vqiind9lx6zjmxjrr22wk";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
