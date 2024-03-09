pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-machine-learning";
  imageDigest = "sha256:e452ed6c048e470127952531a24b5dbc6745cfc52623f12a9c7d7a7ccae2b362";
  sha256 = "01qn4ajickj3ghs6mn5861nam4gyh07gd7r1mvzx37klvj43yhxf";
  finalImageName = "ghcr.io/immich-app/immich-machine-learning";
  finalImageTag = "v1.98.1";
}
