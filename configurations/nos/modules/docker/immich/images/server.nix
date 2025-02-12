pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:f8a3c78ec0a0ace20517acedaab9c2f3edcfc9b96e03080ba401acf55792470e";
  hash = "sha256-hkl1eBL7PaBH06THleAVRm/26hKimeUnKKOR2tdatXI=";
  finalImageName = imageName;
  finalImageTag = "release";
}
