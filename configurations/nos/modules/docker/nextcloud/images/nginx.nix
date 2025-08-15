pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:33e0bbc7ca9ecf108140af6288c7c9d1ecc77548cbfd3952fd8466a75edefe57";
  hash = "sha256-dBUxXjg9cq/cq8XTW9UrJPBazXqmQGrhe5jO8FJjVTo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
