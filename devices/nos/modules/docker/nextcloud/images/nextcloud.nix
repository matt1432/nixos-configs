pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:5640795ab708511d584f9e21d7c468f7c3533c92b5f216075b1883bcca4df91c";
  sha256 = "0im67rbxlkpa2zgr0d3ql6yg9jhj5xjw8f0gk397wixh0761psab";
  finalImageName = "nextcloud";
  finalImageTag = "29.0.4-fpm";
}
