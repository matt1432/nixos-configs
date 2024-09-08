pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sonarr";
  imageDigest = "sha256:138998077a802c18b76c26636301fcd5517b7bfaf75db025d457199176078a12";
  sha256 = "0f66v03cb77sw43g1yljsdn0vsf40hdx332lkffaqfc0nywlspsy";
  finalImageName = "ghcr.io/linuxserver/sonarr";
  finalImageTag = "latest";
}
