pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:fc880c1bf665b4aab1e74c15e56ab871225989cd546536e6b77e771869af06bd";
  hash = "sha256-g9847etf0T5srlzYkf1CeJg9uCU+XBip79zH3p6H3y0=";
  finalImageName = imageName;
  finalImageTag = "release";
}
