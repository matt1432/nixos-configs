pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:5713489fbb1daf3eff5e2e78071f7ac0ba55d56ca59f04fb579f02434b43c142";
  sha256 = "0020fhcx7lr97gvx4chxs5xp5rm41m5aig9fm6zcrk032kfs42pa";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
