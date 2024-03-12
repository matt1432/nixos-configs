pkgs:
pkgs.dockerTools.pullImage {
  imageName = "lscr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:e211fb0366a98952dd8befd92184a2a37b7a4c2c1652ee1d91f7fa2487151b5a";
  sha256 = "14fkslik1i1p9bmgl03hjqa36pzl8r7l2mjb60qg4x661g651nas";
  finalImageName = "lscr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
