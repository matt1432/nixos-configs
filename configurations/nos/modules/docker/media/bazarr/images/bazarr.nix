pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:5d916d07404296ec35ee726e13e0e558f05952724cf494a7f009d913fb2b12f3";
  hash = "sha256-Yh/lGmOrm7/SaCNwPQIzIf2rs4klPj9yYkiXjYRa26k=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
