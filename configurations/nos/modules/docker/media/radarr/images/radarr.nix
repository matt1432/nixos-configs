pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:eccd80c53e55572b91ae205eb572e16b3e012631892e74be7ccedb6d5fafb630";
  hash = "sha256-CYt7kePS7ijvzvFfEHqyYmrr7nJmk5WUBnUzEF5rcKE=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
