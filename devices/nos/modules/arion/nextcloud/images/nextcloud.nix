pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:3a77dd75fedae5c1e28b786f82e5a71c0758036d4991c5713c1513b6daa34358";
  sha256 = "121a4vpp8wnw3z6ngpif4pyvkannxf7jqk6c2zqhl6lpkv9sbm0v";
  finalImageName = "nextcloud";
  finalImageTag = "28.0.5-fpm";
}
