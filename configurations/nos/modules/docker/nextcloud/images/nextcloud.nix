pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:04449c5ff559648208fc71884972b2b23e6ad5ba3af31e1614a765a78e82d38b";
  hash = "sha256-nu+CKe1/EmumKPyNzSKSJrH7SihaqIZsTwJV5uKsfyk=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
