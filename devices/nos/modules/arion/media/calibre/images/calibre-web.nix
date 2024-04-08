pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre-web";
  imageDigest = "sha256:584366bdcad9b3e9e1143d9ff5b012f684f32071d515f532953680af7fa43418";
  sha256 = "1x3bkb2fv9vs30wy9b324wm956nv3zzh1wzn0z08ml4bpncyx61s";
  finalImageName = "ghcr.io/linuxserver/calibre-web";
  finalImageTag = "latest";
}
