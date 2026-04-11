pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "chromedp/headless-shell";
  imageDigest = "sha256:74e466462498480420abc2a77c49fac64382404ade51ce518d45d17e9393dff8";
  hash = "sha256-I86kZ44WcPCTVpvL6QDS54iJii5hx8X+GEV3Jvq/Vfs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
