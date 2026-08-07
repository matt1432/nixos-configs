pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:e464484e7e6cff8ee189036c9ba96977ab054104ea18067ecf6171d0f3f3f8f2";
  hash = "sha256-2hWkAEafbIxFGp0dxsLT1dA5j1+BnHLDmnEnEuyp6fk=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
