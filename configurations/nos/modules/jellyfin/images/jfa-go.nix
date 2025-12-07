pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "hrfee/jfa-go";
  imageDigest = "sha256:d1e7a8dd67246dc3c08fe67213561369a9fc982ffe91a78a1cd60b66381cd260";
  hash = "sha256-IelVwcE9MGohLcB0SH5bb9JLSA5JxNnmi1dCoaqX0Fc=";
  finalImageName = imageName;
  finalImageTag = "unstable";
}
