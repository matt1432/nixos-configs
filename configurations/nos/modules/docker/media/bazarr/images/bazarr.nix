pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:c99ddc0c3a6c23edec34faf81a21fd9bdb60a02b3b5d916590b7a7e48254c87f";
  hash = "sha256-poQ3N0Ad3ZR6UJOzx5otoLttXj9MWjP3dpYg8kjzXc8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
