pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:dfbce5095045fc1c15058318342ee590ab50379854b13464dd2ca17b10c4beb4";
  sha256 = "0f0j5ci4x23xm79vczp1i1m68nqydkqy1qad3k7gqmkx7zl3b8rm";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
