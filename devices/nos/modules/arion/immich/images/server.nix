pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:5d46c02f171b2c85c5c445ed9ae233d68568b241e14e293b0195d539b98de42a";
  sha256 = "1m6yv9v9dd3rf0dg0whyjqpf22zwb35ykkqabhal9qzryv12yg18";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.98.2";
}
