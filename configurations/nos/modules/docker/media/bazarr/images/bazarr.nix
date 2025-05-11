pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:558d6ddf36cd87bac5d4fb2ee8488730c4f65718961ef4ca7073062378aa7641";
  hash = "sha256-cfxVm4w/NFH1JbSByNAV6/Q5DnYRVKbizd/7nE2zCY0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
