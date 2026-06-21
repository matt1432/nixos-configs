pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:8e48a2950e3806a2a914fe031fa21b1c0a0f2824eede4ea747e26213e941fbf2";
  hash = "sha256-PYOIFETnUtwvH4pJ7056JndhuDnXfVhp9QWmgQ/g85g=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
