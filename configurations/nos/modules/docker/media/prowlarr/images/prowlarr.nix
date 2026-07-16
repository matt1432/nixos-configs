pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:4fd7a166c8f46dd3370a871c250ee577d6c2ae97a0dbe0e3614b5ef736205620";
  hash = "sha256-Gj1BbZbemtlkAVoX+d1uAEOq49dmg3KE9NQwNe6iKuk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
