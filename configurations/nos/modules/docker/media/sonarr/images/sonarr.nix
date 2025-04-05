pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:7342ef32dd9cd6d13638765cfb8034edd4c80b0584f427159fd7f5ddeef5399d";
  hash = "sha256-BO/g6heudVKeIj/evjnFzFw2vyLaKZs6DMYGgdkMUtI=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
