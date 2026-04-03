pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "cyfershepard/jellystat";
  imageDigest = "sha256:f7f56aabad139faa996b8bb21a36dd3e65f7c87e10408921815b95a28a4efbaf";
  hash = "sha256-CvIwYfgKTChAUIPgtSm4rpyPhRTfHgIDY871vdGXxag=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
