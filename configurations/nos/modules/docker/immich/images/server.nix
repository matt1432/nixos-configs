pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:ae13784ffcfcce8f4178113eb6661602a1fd1912f3d539880b8ac0dd95fc8ac2";
  hash = "sha256-1Q95kmyYGJXA1udT6PwOS6C9n2A2pXm54dHjnieDKec=";
  finalImageName = imageName;
  finalImageTag = "release";
}
