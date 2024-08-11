pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:bffa87787eacff9023df4400f521c159566d14b5a280caec8b54196071e6038e";
  sha256 = "067zjys8ax1vrf5jj4lafvsnr8hlzcz37q28as7y3v2knlkll53v";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
