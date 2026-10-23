pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/gameyfin/gameyfin";
  imageDigest = "sha256:e884cd56635aa802fa21489ae3a34ade02bf8517604c7fe288f1aefc50a8c1a5";
  hash = "sha256-H7f5k6Mlh2bg4FHGhtSwFqZKYwHJ9bnjctIR6l+JOMg=";
  finalImageName = imageName;
  finalImageTag = "2";
}
