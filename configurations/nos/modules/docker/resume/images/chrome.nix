pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/browserless/chromium";
  imageDigest = "sha256:b0adebacc9b737505e3de46b1feec1f184410b22091a778f94fd09bcc48806f1";
  hash = "sha256-8V/7PnBii9qpQHSEoBH5j0vGIQGGfQF8SvXJFrbvnSg=";
  finalImageName = imageName;
  finalImageTag = "v2.18.0";
}
