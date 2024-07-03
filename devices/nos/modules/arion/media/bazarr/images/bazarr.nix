pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:a113dca480a1e223c1ea62261650ebb56d659a8af5455e50ab5ac1f13ef21707";
  sha256 = "1bh3xganlay5pzv9sjkd72j9s13x2p3v6l3gmz7vinrm5n3pinbx";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
