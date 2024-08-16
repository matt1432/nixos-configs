pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/immich-app/immich-server";
  imageDigest = "sha256:c4e817f0eadbd9a6c2699cc884d5e7070428daec813c17db77d31fcca5b78ca6";
  sha256 = "0vvyhijslldj7hpg33n2cvpn5wrn9fcprw8pw01zh4ziabyy3z07";
  finalImageName = "ghcr.io/immich-app/immich-server";
  finalImageTag = "v1.112.1";
}
