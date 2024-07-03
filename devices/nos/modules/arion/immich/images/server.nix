pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:75746006b35a7bc61408cd4d124dc73344f0a087c2d9769c4715ca84a1d87591";
  sha256 = "066j9ihn8kwznq8m0hpdayki2sc4ijwry5bc47vg4lif4dbxsdg3";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.107.2";
}
