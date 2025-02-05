pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:2a453914efff6156786247b2399e6f9f18d7fc37e1ca5574a23aba172cf37d3e";
  hash = "sha256-9B1g88LSeLpyAxMF4C2EMoGPJRRYQk65ICPIOHjwBrA=";
  finalImageName = imageName;
  finalImageTag = "14";
}
