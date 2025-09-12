pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:e84397672fce21223933cd4f9b09fdea0c1c72daa834c57a613121c927b2ba61";
  hash = "sha256-ujQqcEtH/OIhj7MgUnw9+ERYiw20lBB9tTnBey7peS4=";
  finalImageName = imageName;
  finalImageTag = "14";
}
