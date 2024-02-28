pkgs:
pkgs.dockerTools.pullImage {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:153defd78a3ede850445d64d6fca283701d0c25978e513c61688cf63bd47a14a";
  sha256 = "0hgmnj651lyhf6rca0y0x5b0q3f1pv8h1rdkb2wmfxrng7wwjrg8";
  finalImageName = "quay.io/vaultwarden/server";
  finalImageTag = "latest";
}
