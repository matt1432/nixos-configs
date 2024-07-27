pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:9de91632ea5c0aabcd5558cab8b270f6bde00679fc6bdc35806fb49367e4a583";
  sha256 = "13fpv1gjl04shczi3vbzj4sqpzpmyxw8bqldpgd8h7rhmvs6gjzi";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.110.0";
}
