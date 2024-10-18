pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:29088f7a332ae59f57b0b121bd9d6c6cf0dda1c536c8b7c889f28182e1c26601";
  sha256 = "00r8l6h2wjqygr9sarp5s6a20gvj1rw4wq7qqmdrl0sm13vzficg";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
