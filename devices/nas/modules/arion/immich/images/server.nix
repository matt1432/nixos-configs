pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:c7b80752d48464dea1c4495ff810365a0809d89c2ac219547d3c1aed81c6411f";
  sha256 = "108ipvbs8fns3dq65m754q7f82d3pgk6zig1ajixbvj9p0xqwh9a";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "release";
}
