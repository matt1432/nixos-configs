pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/thephaseless/byparr";
  imageDigest = "sha256:453ddd73debc110f42290d6d3b2bbe9b53c3ca7fed03beedd34538efdab46ea0";
  hash = "sha256-GMht5pP7i3DrStKtW0bQlwLY9fg61jOrKup7h0kGaSo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
