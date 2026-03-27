pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "getmeili/meilisearch";
  imageDigest = "sha256:54f0cca5442af756ff0254e3307cfd846605facf9b6989f571f6b1a96deb0c7c";
  hash = "sha256-SjGPXNWpqRWxTO1Ml6A0oS0wJ1I0Oz9HvOW/Z9pzGRk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
