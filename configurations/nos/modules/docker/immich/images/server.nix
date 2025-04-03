pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:7e5b6729b12b5e5cc5d98bcc6f7c27f723fabae4ee77696855808ebd5200bbf8";
  hash = "sha256-4+AK8upcMkTYmTxrp19qfO0yXNHaRs67UnGz9r5v7xY=";
  finalImageName = imageName;
  finalImageTag = "release";
}
