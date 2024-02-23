pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:24e3d19ce514f98ccde8e4e69e0ed1703dd2a3c398acbcfd49725b18498fd212";
  sha256 = "00cl88klkqgj4xdiydabaxhrc4m0ll75s9sayp4h0rlzphf5qpjw";
  finalImageName = "nextcloud";
  finalImageTag = "fpm";
}
