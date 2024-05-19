pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre-web";
  imageDigest = "sha256:f9e7956e41ccc32c40427f3231bbccb72b4ea6e37023509104c4e50bbf3da8a5";
  sha256 = "03xa64ln9mr1g8zk9jadmk855ivhg7y9d7ayzh2f8jg40ggq8bkm";
  finalImageName = "ghcr.io/linuxserver/calibre-web";
  finalImageTag = "latest";
}
