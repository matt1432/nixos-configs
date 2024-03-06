pkgs:
pkgs.dockerTools.pullImage {
  imageName = "nextcloud";
  imageDigest = "sha256:9b15579bfbc88b9e9f63b769ce602e15ab0cc2f12d6cf52dfb9dd1231fdb1d36";
  sha256 = "17mjs7jkknv3qvydbblqppfmjz2piprk8bpycb80wqvfb2zmcrrm";
  finalImageName = "nextcloud";
  finalImageTag = "fpm";
}
