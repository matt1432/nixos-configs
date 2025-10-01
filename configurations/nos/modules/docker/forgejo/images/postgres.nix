pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:43d23e0db247ccd7caa7b49541e554c7b106947f756c8c8d44b9bc7ae23ad8af";
  hash = "sha256-ydnS5rIGGWwYQLxrSQk8mo3SI3QqOivJSuSRtkEtCY4=";
  finalImageName = imageName;
  finalImageTag = "14";
}
