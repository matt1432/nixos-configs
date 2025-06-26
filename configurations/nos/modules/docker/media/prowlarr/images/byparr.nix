pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/thephaseless/byparr";
  imageDigest = "sha256:2f444712578eae74508dc1e100900114b08e4421e708cb13b07f3dce76a7d956";
  hash = "sha256-KyVilKjwHgH4HSpkU9a/vWwEnfWzVoEvq5A/uzZ+QGg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
