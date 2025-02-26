pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:0a8020afc5e3dcad1413ba125a980729a2b16ff0d88d108b3e1779111ef1c896";
  hash = "sha256-M7zOMg43y01fV1VNI/VhrNAT203N2qry8x1KC/OJQyA=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
