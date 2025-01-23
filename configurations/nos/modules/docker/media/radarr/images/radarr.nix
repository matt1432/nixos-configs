pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:6edb323c959c4e664a46de4b6ff612cc05e190e42aba08b8d61831a371d46a93";
  hash = "sha256-Cg6/4x1mSR6ClXmLrwxOWFKLYYaj0qltDhV3zbMjMKg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
