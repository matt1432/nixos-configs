pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:40f10a3d826f6c231d338738c3c86bf0d23a9546f20f8b1b504c6c579b79992c";
  sha256 = "098dys6m34dr80widw884pik4y0cm18qxaqzlrybmjll9nd3bj51";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
