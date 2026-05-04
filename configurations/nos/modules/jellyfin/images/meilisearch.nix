pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:5d4e1353927785744486fe317d263f442710ab5b27b1983aa1b719dfe2c665b6";
  hash = "sha256-0yz66BLYj6FLEoNQ+7WYQNZVyKOMy8Wx2FEavwaFsks=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
