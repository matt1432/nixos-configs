pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:6c10e1133bc42649de220fa9e04e4c7bbe5ba4161a275ac1494f2bfd45417507";
  sha256 = "050fmdkdpg5ixmj62yzgmhipqqdfizpdlqawfx32550622cs9j3a";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
