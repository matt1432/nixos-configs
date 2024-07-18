pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:31ea64a7ce1e9a5ff8187f9b7c905eaa1d0a79d49b04724e47059c67407157eb";
  sha256 = "1n1gbnvhgbysxiajp8l9akjg88fdw4qz1mlvzfnnisgnblqs6a01";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
