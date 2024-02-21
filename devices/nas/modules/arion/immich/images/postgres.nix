pkgs:
pkgs.dockerTools.pullImage {
  imageName = "tensorchord/pgvecto-rs";
  imageDigest = "sha256:90724186f0a3517cf6914295b5ab410db9ce23190a2d9d0b9dd6463e3fa298f0";
  sha256 = "0h1s11z5d4svg2whm7gw11dwpddg5k90fp62q3zirycms787f4d3";
  finalImageName = "tensorchord/pgvecto-rs";
  finalImageTag = "pg14-v0.2.0";
}
