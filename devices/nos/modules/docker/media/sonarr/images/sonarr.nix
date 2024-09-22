pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:98c21a64377619ec74778c70cc2e74d3e978a4d2c61f97b9ad88a0e5bc0766f9";
  sha256 = "13zp6argbfqb98dx67sqar2iy0lg9xw9xbh94l5339j6jzpwi59h";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
