pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:bc5eac5eafc581aeda3008b4b1f07ebba230de2f27d47767129a6a905c84f470";
  sha256 = "0v9y28znr1rw77dv96p8h7zminw179d0fjif8scj15zcwxl2sxhy";
  finalImageName = imageName;
  finalImageTag = "latest";
}
