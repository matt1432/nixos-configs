pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:544fcfc41ce97833e33126e5041fb3b821e3db7bf405b54ac06689247a170a90";
  sha256 = "sha256-DtjGS/NI6xLMDe5K0ErlDtCX6SiburRlB+Toslj/dyo=";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "release";
}
