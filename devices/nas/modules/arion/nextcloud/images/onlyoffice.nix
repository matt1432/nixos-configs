pkgs:
pkgs.dockerTools.pullImage {
  imageName = "onlyoffice/documentserver";
  imageDigest = "sha256:3b53dc7da559cdfa7e0c1c2f64aedce0b7ba868080b07c338ef5794a8046ca85";
  sha256 = "023ip2iimlm9h0bhmwwylpwhl2230qjql0z8m96c2365nx0nsv70";
  finalImageName = "onlyoffice/documentserver";
  finalImageTag = "latest";
}
