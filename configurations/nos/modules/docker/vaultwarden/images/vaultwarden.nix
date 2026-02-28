pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:43498a94b22f9563f2a94b53760ab3e710eefc0d0cac2efda4b12b9eb8690664";
  hash = "sha256-pj0ffBwhu2vyzkRUy0qYrhHu02IX87iIzsP9pEnHDB4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
