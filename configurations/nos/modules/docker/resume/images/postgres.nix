pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:edb0c08dc33befd0262ab3b5cf1c4f3f8cfd8b09e88c05b45adee29d6761ddb6";
  hash = "sha256-RH5mrAXM6md6oP4XMehI6VHt6rAlvPV5NAfezHqrAJ0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
