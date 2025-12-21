pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:e6a6298e67ae077808fdb7d8d5565955f60b0708191576143fc02d30ab1389d1";
  hash = "sha256-Y1SlR5U2B4MR4BCpXslIS5b3O45j+U+xWGL8skPQQ4E=";
  finalImageName = imageName;
  finalImageTag = "release";
}
