pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:20b5b6a2845e40ff18cc3b3ae7d9261638f40511ea73c3c9ececd428e95fb43e";
  sha256 = "11v6kk7jgp98j7zd7lp714ci1xqhkklvyxj4ssapwplxggkbh4yl";
  finalImageName = imageName;
  finalImageTag = "release";
}
