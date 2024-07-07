pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/fallenbagel/jellyseerr";
  imageDigest = "sha256:164365db8dc720291ba1eedab14e37025cd6b9e1ba45bebd06dac3bc15305f18";
  sha256 = "0614m68qibqblqj0g48b0cny2irpgqkgs519isw6blxc209z0yan";
  finalImageName = "ghcr.io/fallenbagel/jellyseerr";
  finalImageTag = "develop";
}
