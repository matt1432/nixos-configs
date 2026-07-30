pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/seerr-team/seerr";
  imageDigest = "sha256:f4768de5f616248d723e05891f3345a1402123775d03bf0890dbfedc0831bda1";
  hash = "sha256-XgcwqNdvQwxao6pOJ+VDxu21F8Ov5/Wl9TE1BLdZvpo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
