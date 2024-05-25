pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/flaresolverr/flaresolverr";
  imageDigest = "sha256:0bdf9ed48f3c54c998bc160be46244ce3a88a7783b6cfd31eec9c1667786152f";
  sha256 = "12a82g88kzsr9xdvvk9vwqpxl5xif063s8lwlas7h9iix0i5fqmb";
  finalImageName = "ghcr.io/flaresolverr/flaresolverr";
  finalImageTag = "latest";
}
