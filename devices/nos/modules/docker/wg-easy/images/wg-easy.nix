pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/wg-easy/wg-easy";
  imageDigest = "sha256:f6c2587da3fdc9d5927743fb4a92cff42d690b182396ffd0cdad034becb41053";
  sha256 = "0cswmpw025k4pkaflqrc3lqrzv9gpxvcyg7jcncx306zbiwrnd07";
  finalImageName = "ghcr.io/wg-easy/wg-easy";
  finalImageTag = "latest";
}
