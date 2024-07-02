pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:c5b78b1f1e8556d781788194c4ee2b87ca7e3620b701bfce31499e60ee50eca3";
  sha256 = "0nic5ajl95pwyp11j0mf45frvrb340sqmf2zvxb93rprrwawas44";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
