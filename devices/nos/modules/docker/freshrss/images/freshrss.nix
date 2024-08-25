pkgs:
pkgs.dockerTools.pullImage {
  imageName = "freshrss/freshrss";
  imageDigest = "sha256:126b5202e65bbfef1da19be87fb21d9909e104d3ad185775c999b76a420d30bc";
  sha256 = "0v81xs15g1db0qk2dwmjz7glkp8jlfz3w7df84f7gslqiv2lagn5";
  finalImageName = "freshrss/freshrss";
  finalImageTag = "latest";
}
