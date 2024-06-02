pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:6d682b91bd6f818e0489485651989b1e0c8444b1b55f4e9726b38ab1023cb294";
  sha256 = "1gvkl9m2727vqs1ya9imp1m7j92vnzh8l81qgrrhszph66pzbcps";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
