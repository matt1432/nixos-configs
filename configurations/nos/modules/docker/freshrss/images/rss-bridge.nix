pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:cca783a163635ac0e948af321da7692b071565f1f2c0fd5eca40976fa2a7bd9d";
  hash = "sha256-+5qhhoxa6qy0HmfUEdlG0ZIlQy+AsvyYY3xk40yH6tw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
