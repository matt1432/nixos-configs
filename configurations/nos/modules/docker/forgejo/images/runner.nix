pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "data.forgejo.org/forgejo/runner";
  imageDigest = "sha256:e070b166b921f12a2abef432cf6108e63519d0183722c2a14ecbb8d0b0621652";
  hash = "sha256-zXivKA3PCZD2aBp7AfpRHaVJFuZvUMGkvyCsOoI3T0Y=";
  finalImageName = imageName;
  finalImageTag = "12";
}
