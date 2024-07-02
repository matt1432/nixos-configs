pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:3f193d343c1225676c1ea0547c5022fd83c4459a493870179dff9e87c54dbbc9";
  sha256 = "1qksj4njjl8axa2zy1iazwq0kg2cjdzzy055ylwgvq1zv1by45a2";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
