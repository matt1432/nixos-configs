pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:38149fa4fefab1e56a976d37db0bb22a049c4e6faf4e1d755fdc536ff5e7f69a";
  sha256 = "006vd51qnmy30jxyfby870fwxkzi832ll5jhi7fkma4hkh8h44vn";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
