pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:d9eda6d9bd651886631f01f3ebb1ff33f9f5d04f0fd95be8fb22bc1a779a3d84";
  sha256 = "1x6h82x4y75agl211z573ggh9znaxrcal05jjxn6z1nvd1l558kg";
  finalImageName = imageName;
  finalImageTag = "latest";
}
