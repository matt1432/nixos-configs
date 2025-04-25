pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:2219fa5f4db9b33fa187553177daae80e7baa6b0350a3132395c7bf6b4ded771";
  hash = "sha256-UF0vOc80YcXwtQjFI7ylvSd1BRlnzakmERNkpXwWwT8=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
