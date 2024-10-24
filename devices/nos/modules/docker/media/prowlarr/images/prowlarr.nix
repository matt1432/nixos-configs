pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:1e2fffd859ecd260e4aae4798cf5be75938cd602161d21b1d58122afb397c864";
  sha256 = "02al6d5jl4avj3jyrvpp3d8g5vq81n76aspfv9s91fbmjgv9g60p";
  finalImageName = imageName;
  finalImageTag = "latest";
}
