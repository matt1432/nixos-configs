pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:721f7e5a8619e2b77569393bda271538f5ae21686629e0e3abe0fa18599e08fc";
  hash = "sha256-TotMQiL6uhPJ+N3sO0+F5dD/R9BzYtm/XlaD6D5Aq7o=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
