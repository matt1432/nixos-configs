pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:041b2d22b8d9138ba80fe3a1a01adbb4dc41ea434fc9700799b9d5dc809f6511";
  hash = "sha256-Ty8h+xpFf8kOGyoezXRrjk1gqyFhoXHAYNvyPgPXze8=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
