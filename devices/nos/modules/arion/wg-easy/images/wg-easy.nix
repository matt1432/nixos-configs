pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/wg-easy/wg-easy";
  imageDigest = "sha256:4c2c591498aa910ce86a90fa00c4714ffd78dd7556b1f488f226471b97346bc6";
  sha256 = "1p23cig6b1xd5w84cqgkycs17mw78bz1ks4csp006hqvwdsrr9wi";
  finalImageName = "ghcr.io/wg-easy/wg-easy";
  finalImageTag = "latest";
}
