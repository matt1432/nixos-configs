pkgs:
pkgs.dockerTools.pullImage {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:423328ee377374c48a30c2aa416e4afedf621faff068f97966cb9b87a28550bd";
  sha256 = "0jdd8h5piiy9hdssb873kn35a3ragl90qmll5rcd3z0k14ab182v";
  finalImageName = "onlyoffice/documentserver";
  finalImageTag = "latest";
}
