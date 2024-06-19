pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:7cef47ba7fd105e2352b48fcff50c43a78415511beee2f742000cf9de5609331";
  sha256 = "1lx3bcffqs0dn55826xx4jdysa36g7dy5hakhazfyxzv7wixkh62";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
