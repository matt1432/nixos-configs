pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:e8c17c1734e9e6a89989264aebae20bb9f05c16d16f33fa62875d9b83a7d244d";
  sha256 = "0fxdmmm1n0c4sm3g1s73d6nb19mizarslq2lb6k4rpcrdrrdbh7a";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
