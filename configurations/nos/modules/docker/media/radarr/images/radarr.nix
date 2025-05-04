pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:3a220dd02a24cb3610441ec6811bf70846e851e05f3219ec4801a06bd0646912";
  hash = "sha256-bumM4fCHtKQUjPqZ/c2+ueFVlPcQBOmHavOG49ZkUDs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
