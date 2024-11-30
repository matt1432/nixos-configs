pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:401f80f28223b2ec3d9e7026d83f61f99e224a1013967fec2a808074faa04449";
  sha256 = "0im661ra3i1hl8gag6wp7hfxaxhfiisj5bg13cisrvhp1yp032q0";
  finalImageName = imageName;
  finalImageTag = "latest";
}
