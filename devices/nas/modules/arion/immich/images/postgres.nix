pkgs:
pkgs.dockerTools.pullImage {
  imageName = "tensorchord/pgvecto-rs";
  imageDigest = "sha256:0335a1a22f8c5dd1b697f14f079934f5152eaaa216c09b61e293be285491f8ee";
  sha256 = "1930m92kd3jxn1d6fj5py6b6rldvswhc4vyn9qkx98cc9v81yamc";
  finalImageName = "tensorchord/pgvecto-rs";
  finalImageTag = "pg14-v0.1.11";
}
