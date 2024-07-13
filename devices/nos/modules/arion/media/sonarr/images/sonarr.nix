pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:a9f25c54b7eb8ecf11e506e90ee7eab9e9786143e08eeb76d5bfc3e82531eeab";
  sha256 = "1mg2bnx7iynmma3yajji2qg17p41w0ddv66ir9yqf4njbjky2mw2";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
