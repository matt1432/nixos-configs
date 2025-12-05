pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:d459b8886c86fbe85d7acb052fc1cdf4744fc119720440943357608ab4121169";
  hash = "sha256-NyVZYe0qtfp6hXIxkGQhPhk3Z31ClMLPpq2OIWjCEAQ=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
