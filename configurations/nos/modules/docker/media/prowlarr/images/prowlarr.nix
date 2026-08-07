pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:1295cff29d10b486c0d8324d1559a552140a5932bf8b3d87e398654414f63f92";
  hash = "sha256-/drrJ/bRyWmaEFKwm4EPVsAf8NuwcUTOnrad4r2ov04=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
