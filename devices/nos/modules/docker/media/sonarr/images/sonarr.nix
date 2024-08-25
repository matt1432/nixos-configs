pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:0777b308a414000505651059a95af373ded6aba8ce5a40b50d7aad333dc912e2";
  sha256 = "0idkny0m0jjl59vd1ja7bb7fc4a37v2y1kjbi6s661jcn2pnfyws";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
