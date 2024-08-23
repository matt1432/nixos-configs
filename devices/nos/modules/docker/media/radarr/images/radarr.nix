pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:b034531ff81d3e5e1f9fd70c969746040b40e6484c88981ea5d0dee732c10bc3";
  sha256 = "0f2xbmad25nb7l18pk1424dgv0k23m0bpv25bf7bgawb98p1jgdj";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
