pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:7023a5bacf495af43aafb4257ac7d14fdd9804f075c416855a7fc914d8fe743d";
  sha256 = "0z6hfq2y75bq9fkgp3dvdm2mcshzqz8qpvd0byng2bhxivrsbh4m";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
