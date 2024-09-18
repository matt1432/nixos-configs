pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:71f545e4a6cfda02798fd531bfc27b14cbf7345bb28fe503467fb1ab13c3bfbc";
  sha256 = "1ibq19ixkls3dwmmqcjz9ybia6fmyw5bb0zmx5sl53qnnbr707j4";
  finalImageName = "ghcr.io/linuxserver/bazarr";
  finalImageTag = "latest";
}
