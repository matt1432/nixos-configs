pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:8b9f2138ec50fc9e521960868f79d2ad0d529bc610aef19031ea8ff80b54c5e0";
  hash = "sha256-XbDeXSJJ7eI6iZhl2eaDwz1ztSzVKpo3SEE6Z0VRpo4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
