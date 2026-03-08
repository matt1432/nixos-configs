pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:f8e8ec1321049ee2763453f3df4d414b012e5dcf92d3724ef86e9bbd8a55e708";
  hash = "sha256-4dVUTsdVYTUUfG+0HKaUVVN7M+GdDFkaj5NZh7fn+Wo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
