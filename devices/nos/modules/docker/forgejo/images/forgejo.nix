pkgs:
pkgs.dockerTools.pullImage {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:818fd892add3c6ade24ece9cc498301a44f68b844bd21abccf4795e7011094bf";
  sha256 = "06i7f7jy39mh920m8l2nw98ds86s2lv6q7i1g1l5yy4f6fvsh1k4";
  finalImageName = "codeberg.org/forgejo/forgejo";
  finalImageTag = "8.0.2";
}
