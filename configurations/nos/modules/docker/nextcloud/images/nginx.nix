pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:42e917aaa1b5bb40dd0f6f7f4f857490ac7747d7ef73b391c774a41a8b994f15";
  hash = "sha256-/cRsGy2N0RDeNigyUqOEDQbuExEKAnLPF+3XzV+We14=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
