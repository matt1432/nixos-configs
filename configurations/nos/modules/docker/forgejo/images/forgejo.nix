pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:3eb3107bc9de4e9d6d9e539044e6c802dc0b7be351919a145540d4cb5422bf07";
  hash = "sha256-Fo7TMg9jm7Tql4dbiaVlFOqmEBPw8Ev+Cm5WFUGBPbg=";
  finalImageName = imageName;
  finalImageTag = "16";
}
