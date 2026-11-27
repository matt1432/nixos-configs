pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:cee0d2e31191594ff8e1651eb144aabd95b389a0bc3532327ecfb9ed91dffe7e";
  hash = "sha256-Nv/xsjSjzvVYG5OzOLgBz8S8KlgCT6XRgGVIUpM79xk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
