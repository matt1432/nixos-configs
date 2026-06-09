pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:cbe0e500a5fc04397dfe0245cf143fee40658b26470daaf549f0a6927c5c08dc";
  hash = "sha256-YxhLMMfvyEfqCluRv6y5X7xT7ZlhsXVZHB5agYXO8y0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
