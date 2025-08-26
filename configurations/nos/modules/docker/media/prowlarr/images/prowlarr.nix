pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:4f2a6d597845b2f3e19284b1d982b3e0b4bd7c22472c2979c956aa198b83f472";
  hash = "sha256-c8w8XMAToNooshbB9682WAzA748lGitbJOvDX6Xz72c=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
