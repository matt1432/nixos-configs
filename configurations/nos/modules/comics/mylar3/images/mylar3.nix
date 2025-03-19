pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/mylar3";
  imageDigest = "sha256:124eb1d44d7683fa05fe586b8b6eb04311f2cf96891a1107adba47c74a774b1e";
  hash = "sha256-R3LUytujJNJcakTRW/3i8I+VVfiOJZKWvsNtLoqyfsE=";
  finalImageName = imageName;
  finalImageTag = "0.8.2";
}
