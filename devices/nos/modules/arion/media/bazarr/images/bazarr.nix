pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:a0e29beef27c757205aa89193c691637bfb4edabe26ff56bff2a7a4d61af3641";
  sha256 = "1fa147kixx6qz38z3m0gf4dhk6ja0bf9slhdr78l2mln41qxbks4";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
