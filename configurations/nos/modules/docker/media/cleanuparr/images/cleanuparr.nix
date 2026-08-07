pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/cleanuparr/cleanuparr";
  imageDigest = "sha256:31f93b0f8eff9fe87c5cb7779276905144bc297b1a67cd77887d8eb168b1af2a";
  hash = "sha256-WcyAExPeEfmAr+w/Mmbj6jey+8qjGGX35eah+KLQfxg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
