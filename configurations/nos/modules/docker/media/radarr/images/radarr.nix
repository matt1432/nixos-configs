pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:084b3b2ab1d0ef930660727259546a241f2bdf67c9ed085d54bf1486a6887c9b";
  hash = "sha256-hPCAsaaz6XcKw3IVN4dSjh+sLh86xTaJdg9ECRCCWYE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
