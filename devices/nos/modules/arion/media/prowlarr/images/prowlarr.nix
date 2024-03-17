pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:45653c80088612dc51e54bef59e09c004fc9bcf0fdd805d036264da8cbbbef18";
  sha256 = "1x0wna555q8qx1n4h1awlrf4bsly8zy7gkj5dbn8368gy7w8pf1k";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
