pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:eb73e7f8296e432736ea424c0af899132c6d3dbe090313ba5e3b30f8030cb7ee";
  sha256 = "1r33hv577qh7p11q7l3s6ia1r0ka64d2hg5llcxgx10c6d935ccx";
  finalImageName = "nextcloud";
  finalImageTag = "fpm";
}
