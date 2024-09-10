pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/gethomepage/homepage";
  imageDigest = "sha256:5c264918d2d18a753da8657fee7e0579c8b11581b19275d9a93fde76a8267f3c";
  sha256 = "0cj635ig2w0bjz31mmd7crmkgz4vqm8s03kn19b9hk18id8ja9py";
  finalImageName = "ghcr.io/gethomepage/homepage";
  finalImageTag = "latest";
}
