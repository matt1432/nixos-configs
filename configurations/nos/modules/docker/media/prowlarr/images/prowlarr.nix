pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:ec80f415336c11d1e1cb0f749c3f1296ca018205c1acf6140618e98894e1498f";
  hash = "sha256-LmckOGwkhLZ6Whjyizdg6A+fJqV6gf5+2iw6X7os590=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
