pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:be3ef05cda03e27a32f23ec073ce65b53a115338559abe3639f796436a652f9c";
  sha256 = "1sd5v4fz9cli2jhq95n5rx243yyc3dgy2bnzi5ahzlg2djn7ryyl";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
