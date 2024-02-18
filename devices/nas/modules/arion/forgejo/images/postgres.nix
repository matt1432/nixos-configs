pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:34f4ee87fed96f254c4970e6a348c24b24b4f05ebb0880e29c8d15a5cde4e763";
  sha256 = "0s4hh6asc7r7qa0dbgzx9dqfhrap6xap17a0hyjfhhazq270flsl";
  finalImageName = "postgres";
  finalImageTag = "14";
}
