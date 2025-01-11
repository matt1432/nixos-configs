pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:c14dccad0611635668abf98f17ce87c3badcc17bb979c53ef96dc49e934ebbc8";
  hash = "sha256-9q84+Ueybv5jXRASWfBiQv62+gzHk8TDFjO5FsTxmSE=";
  finalImageName = imageName;
  finalImageTag = "release";
}
