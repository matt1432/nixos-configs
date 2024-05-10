pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:6bc7267423c3f343ec50efff475c882f4a638e61fbbf53444b94c622d903d94a";
  sha256 = "119r8jxp7ks5m76a662vxiza2jfcwz056slkw8n0vxy81bifnfzd";
  finalImageName = "nextcloud";
  finalImageTag = "29.0.0-fpm";
}
