pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:74e016552a6f908fa3700c0dfa3757fb20f8ff2a630cd357ebbdc9c359a53bf0";
  sha256 = "0ysq5fh4dkxvprzqd9wdsrwwj7mhj3a2nsinwz14r7shv1jzhra8";
  finalImageName = "nextcloud";
  finalImageTag = "29.0.6-fpm";
}
