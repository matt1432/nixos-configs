pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:544fcfc41ce97833e33126e5041fb3b821e3db7bf405b54ac06689247a170a90";
  sha256 = "10dc6srf1wd5w0zm0p977xfsbd73ljzl1lbld5wk3k3l2n1syzpd";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.115.0";
}
