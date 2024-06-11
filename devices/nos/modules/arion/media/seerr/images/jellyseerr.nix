pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:0bb9f0c6e110ed2d621972054ae221b8a46364ea69922781ccf0821722c6831a";
  sha256 = "132i3dy8r97yamdgfnj8hbrjp121r9pxgs71khsjs2jd2l4kh0yi";
  finalImageName = "ghcr.io/fallenbagel/jellyseerr";
  finalImageTag = "develop";
}
