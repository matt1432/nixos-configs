pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "grimsi/gameyfin";
  imageDigest = "sha256:359685c45bfd734b2733d83f7b727abdfcdec9aa45c0359837e3a0ef8af1bbac";
  hash = "sha256-mpkjxmI7AZ5ZebpTo4QQQUw0UMAftmM68DZ/FcECbYk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
