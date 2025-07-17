pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:89eac63d2099477094df8c2329a6a750b8b5e382f8975dd18e7861678b55cca4";
  hash = "sha256-ZObmJERB+zfLYFyXVuhL+5ECMYGIXzD4ADnbEzH3HpU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
