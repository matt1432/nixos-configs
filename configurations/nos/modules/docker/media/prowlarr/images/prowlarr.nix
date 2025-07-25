pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:d2462d470891c70073e31d158657a9b247b317c90238c40534d8be8f98671057";
  hash = "sha256-uy5pgZoMyjoEg4HxXG/OYvOjedAHltKy7lm56ZcJ5q0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
