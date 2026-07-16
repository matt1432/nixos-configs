pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/qbittorrent";
  imageDigest = "sha256:352371a7242e8b4aa10958ca02076d1023758070519b89a10251475fb9f1a35a";
  hash = "sha256-yyDaFpq3wDh30MRb06/7kvyq8jZKwky3cMINmkcpI1U=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
