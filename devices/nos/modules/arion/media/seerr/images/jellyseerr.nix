pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:743fa4f6d66d2e558abc35239c4edeeaed74493728b0717111dea7f003bf262f";
  sha256 = "1x21y0yjlcplk6is87ba0d3caxmvris2qyzclxpj1lq36pkn0imx";
  finalImageName = "ghcr.io/fallenbagel/jellyseerr";
  finalImageTag = "develop";
}
