pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "qmcgaw/gluetun";
  imageDigest = "sha256:4af0c804003481e100180e1f8d4d5e9c48163fedc0f88d061881b615aef9d183";
  hash = "sha256-GCpNkNqPJ9zZ2WIQCTvRCUfntOpbUeRFa6oUsKubhHQ=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
