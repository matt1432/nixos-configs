pkgs:
pkgs.dockerTools.pullImage {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:6f4620d8fb4bb8288315b07ca65286da958745d623fc9eaef4bb4e0e34c68b3d";
  sha256 = "0k9nx7z20b60kavyawdhp7lk3abgy40lsbxl5p2qzgkhrc67bb31";
  finalImageName = "codeberg.org/forgejo/forgejo";
  finalImageTag = "7.0.5";
}
