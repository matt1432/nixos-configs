pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:21a4813c5ba120d72ac5f54869b790792bda0784205268eccbc204adb6dbe485";
  hash = "sha256-5kee3kZ+ce/LvPVo+sBaW8q16MXlhWwFyWuvnpYB3js=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
