pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:a31782bc5e7535c26f7869189d38d433e53e55576487f686ed5cfbdd5d11e282";
  hash = "sha256-0204pLQ2d6s7UqL6fQeCq+jnAkD47hzp2BJ0w0r6e8w=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
