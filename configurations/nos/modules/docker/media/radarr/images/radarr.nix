pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:af03fa6a993ee7efb65f6121ebd8c89de4a47aa1181cec03832e292a1446111f";
  hash = "sha256-7nMDn+TV0qhIWzQUpjP5WziNys6FYGcfnjrgFBjduPU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
