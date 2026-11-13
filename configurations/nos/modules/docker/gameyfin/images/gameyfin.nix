pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/gameyfin/gameyfin";
  imageDigest = "sha256:1042f8c7ccce1ce98b9d6b4314937f80c37c360f2e1fbbe7e4a0a9434facb930";
  hash = "sha256-QGRwuXpSOIlKSTcKrTW53u9W6HlyFQ1LJo7bvhD6sPk=";
  finalImageName = imageName;
  finalImageTag = "2";
}
