pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:f33e1b5087b7dc3bdbb60ceb0e6f32bf0ce06376328d17c7db86fba62b673f6f";
  hash = "sha256-ex1iaRoJ9aOUeRpxgJ/HNM0xhkHXLFUyu5oeXZPT+Rs=";
  finalImageName = imageName;
  finalImageTag = "14";
}
