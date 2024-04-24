pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:d1c3a4e634ab6b7089dfc0b1e70a401972493e9e16a65b3f655b3a07955571f7";
  sha256 = "0svqdm2h9fw58jrxjqncj1w1npafyykqnms4a5rnksnvfi57qy34";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
