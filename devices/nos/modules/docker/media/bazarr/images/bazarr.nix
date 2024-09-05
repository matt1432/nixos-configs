pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:0364bb3d8d03cf0995036140322f6d0de78dd1924ba990499f67598f7c61ff62";
  sha256 = "1i73c9m8nrmh0bz5hvyg71rmyjn06igxwbizhdmsvyrsjz8g0iwx";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
