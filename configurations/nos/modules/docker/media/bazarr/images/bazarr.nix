pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:36f4ba69ab5bfb32c384ea84cf0036b8b6e07fb9a7ab65885f3619de2a8318f8";
  hash = "sha256-tfSewd30img8hQgWsjpdgNwTO6vK1lWqxyHVRkjU9Tg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
