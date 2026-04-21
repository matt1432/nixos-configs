pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "chromedp/headless-shell";
  imageDigest = "sha256:aac539266027f91cf47610da1129dce360d23f45f8f150683cca94223fa2f1e2";
  hash = "sha256-Acabk0dmwNPJvVC2l6j90JUXKI/zA5t4zJOsp+Km0qw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
