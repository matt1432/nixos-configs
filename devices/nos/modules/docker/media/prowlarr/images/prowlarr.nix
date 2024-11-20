pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:c492863c8e1da876a6be3d0d5836f25b3547c0a3293f0e9f09cd198ebf47ea37";
  sha256 = "1i045qgvjvc86554fa86vbbbxxs10zl9i3mhwriqmf9vv7jrgi92";
  finalImageName = imageName;
  finalImageTag = "latest";
}
