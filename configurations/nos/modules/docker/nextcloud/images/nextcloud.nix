pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:9435a81c8241a143ecb04e419b61bcf7c578b075e944a5920329f6c354bc33b3";
  hash = "sha256-vK1AgzLurJmSkutlXo6MFJOBlhfyHO56hdlBBX/9+1M=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
