pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:3bee8fb8eb4bb93b77eb4e0c5d755f25649223965af59f5f0363ddda03c6d10c";
  sha256 = "0nlhmicz1db4kc8rcxnlia5y8gppq55an4ghxvfih9ja4fj6m43w";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
