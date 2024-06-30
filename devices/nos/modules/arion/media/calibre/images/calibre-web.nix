pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre-web";
  imageDigest = "sha256:6416eb62ba1ca7504055436eb688962dc1cab6d8a81615a88c2ee55edb8834e9";
  sha256 = "1a7j98bn4bzgkphlq93vrmnpfzsc1fbb0pnkr5km2jhdgkx41b17";
  finalImageName = "ghcr.io/linuxserver/calibre-web";
  finalImageTag = "latest";
}
