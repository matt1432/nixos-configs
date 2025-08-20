pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:d37a88fb1751c7b9a9fc4d134b8e96c1e32821ee38630770e6a9112cf47fbe55";
  hash = "sha256-oSZM6LUbbRNu9KUWHKsDX7ZpLHziTEhmk+KQESndhPw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
