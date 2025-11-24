pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:95efa352fbca563ff7de649cf841b529404d9d790e3b017de2a43bf1d25a068b";
  hash = "sha256-K6K0gQxFVz1hAfJB5oT1nXopzuiCJGqrQDQ23SVEt/U=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
