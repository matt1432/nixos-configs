pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:aad79c7a696a8743b87f9a0429bf5fa0be1edc8bbf00b962008dfa9893efd28e";
  sha256 = "0dangx6v4nhz80n3viwblb5qh6xa809vd20r6ryp9xd5nblf4326";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
