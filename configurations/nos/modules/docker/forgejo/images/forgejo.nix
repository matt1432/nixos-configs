pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:dbb0f88677f0c65cd1b66fb83504225aa5a04c4bc4a5ffdf9fc9a3a6d5bb1c68";
  hash = "sha256-rNu13e5gDn4MHCFLK4dYdBicbATI7LZQuc1nWXD1FU4=";
  finalImageName = imageName;
  finalImageTag = "12";
}
