pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:094b5689ed81549bd293418395c7cf495ae9d960fc2d4928cef2083ef913d912";
  hash = "sha256-81ToEmBK+36U7Z+F7eSqg58FicZSji3w6owUReYvtYw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
