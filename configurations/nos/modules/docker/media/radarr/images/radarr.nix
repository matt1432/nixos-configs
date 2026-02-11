pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:f08dda38e7d12e5a722d9a5cb6e54acaf63c8598fefeefec88effe0c0d0038dd";
  hash = "sha256-phT+mlLIEhqgk7/rkSqsQ9Q53KJe3+7Z1bfGql89mrw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
