pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:eff1cf5cf51e8375802d6c00d37d2a948bdce91dd17c879f5fd90bc9d5c16303";
  hash = "sha256-LFkfRlOkgRPbYI0xrveCrsxcN33dD26aspvt4h2kPPo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
