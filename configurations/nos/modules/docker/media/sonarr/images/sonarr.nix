pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:7fe49f99201de94a277c577dcce5ef8f1789ead1056c8cf758fac7bf4e601d16";
  hash = "sha256-6Ug/nyWSQwzGQ1vi8Lpg5TmIWwtI1czJh1/Bb76FTFU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
