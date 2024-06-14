pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:e14379fc17d16e902c3d9234425e0da5e4926d3fe1eeb0f1cb4538f4b0618490";
  sha256 = "1apma6asq7pbka2n7jfxry6qy1bf43lnkwly5s3d93zvq7y1r4wm";
  finalImageName = "ghcr.io/fallenbagel/jellyseerr";
  finalImageTag = "develop";
}
