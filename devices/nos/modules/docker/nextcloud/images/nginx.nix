pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nginx";
  imageDigest = "sha256:93db6ea665b5485e59f0b35e506456b5055925d43011bdcc459d556332d231a2";
  sha256 = "1izwcsx4f0skgcy738xmlcqdffkfrisvhpjah1gmzyjwnwai5gjn";
  finalImageName = "nginx";
  finalImageTag = "latest";
}
