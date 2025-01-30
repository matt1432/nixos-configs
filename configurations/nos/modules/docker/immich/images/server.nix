pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:217cddb1e0fa3f4878e1573fe1fd4b9dc24f737015cc5c917910787a5ec0f85e";
  hash = "sha256-8XDmZLrcVbyU2SJen19tru8YKmrwngTnUuBRO2YU8eo=";
  finalImageName = imageName;
  finalImageTag = "release";
}
