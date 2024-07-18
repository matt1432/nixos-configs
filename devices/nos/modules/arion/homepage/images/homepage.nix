pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/gethomepage/homepage";
  imageDigest = "sha256:125ca0a320f7c23b003a5fbce43b282b789b57fd576423d5714e565a4415a7f5";
  sha256 = "0riw3lrjfffc8gzj5ga1ijlkcdv9p6dminpw24jw8isdq5c9pi7i";
  finalImageName = "ghcr.io/gethomepage/homepage";
  finalImageTag = "latest";
}
