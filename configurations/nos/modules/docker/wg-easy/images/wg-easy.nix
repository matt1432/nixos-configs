pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/wg-easy/wg-easy";
  imageDigest = "sha256:5f26407fd2ede54df76d63304ef184576a6c1bb73f934a58a11abdd852fab549";
  hash = "sha256-rEYypX26N68M8ZWfgBb7RR+DizXGSLaQW5X0CIT2ieg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
