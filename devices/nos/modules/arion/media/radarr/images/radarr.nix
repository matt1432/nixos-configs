pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:1afb332d12843163750a40a4e03b0a91b03db8831f9455cbb6fc06ebddbfa16e";
  sha256 = "13axfd2fwscy1s538hlhyvr8b1vrpw0akx3kwkmslhkc1fq62hq0";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
