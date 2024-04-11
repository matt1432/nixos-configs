pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:e6edc90016d19ab9a1fb82e510bb6be909119efe1c7cbe77ce02b0a0843d3241";
  sha256 = "0plwdv662j9mhpc3ld3z222ijmpkxs78i5dz618alsqkqb9nzri1";
  finalImageName = "nextcloud";
  finalImageTag = "fpm";
}
