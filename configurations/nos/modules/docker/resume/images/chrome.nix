pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "chromedp/headless-shell";
  imageDigest = "sha256:8ac7b1c4bbf3d1a7e728c2d1c17eb57cbfa006189052422aa1f013ffd0780d57";
  hash = "sha256-JJAn4fdCWkPErj+e/2c4FtqtYOeRZOOsSuN8LafJXs0=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
