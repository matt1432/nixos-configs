pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:6720a223825e51acd888dc09d8fe41736c9f312791c9a77d8785aac1e4a4e639";
  hash = "sha256-ZOMV5FLRdqIIE+jnZVr9p+Y0wstGf6F8zQntj7BeB74=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
