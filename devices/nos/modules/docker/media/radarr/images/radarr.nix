pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:5ab12592e768d04d94bc04877bee194f372ea3946abc6de689311f4d8559ee2f";
  sha256 = "0w9nnpiphlr1h81qal1b09pv5j1m2bkxmba32id635dcmgp577mk";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
