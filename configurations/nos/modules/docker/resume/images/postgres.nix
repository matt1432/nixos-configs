pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:4ea94de574c17f0372722806c949757050fbb1cd7648410fe45d6bba275cc00e";
  hash = "sha256-rw8PLtgsUeNJkLjFa50VY4jQE74MJt85X52OxwY8Xhs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
