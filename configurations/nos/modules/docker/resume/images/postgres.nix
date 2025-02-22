pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:bfee8fabec7c662311eff39111a890f68a46a78a3b35e91353e185e7d5918517";
  hash = "sha256-eTAIzZABScDXrUpb6IzK74YxxHR7vmc50MNtK9IO7Tc=";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
