pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:f7c4b928848c9901a4b18663a0a89274e89c11637576218e356864d1d5e3218f";
  hash = "sha256-GroCx/MmVYwqSWX9DXbHw60AZVGL+4fDfYn6FFvZXMk=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
