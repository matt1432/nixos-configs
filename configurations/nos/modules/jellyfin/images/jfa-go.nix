pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:325d85b8044ccfe2914f10bf5c491f06500ffb29f235ee0642963b316a5f8e6e";
  hash = "sha256-uKFh0q1rmhDt7lC+Ao/KQnVHQTyWeiCTVxEpnD/3uow=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
