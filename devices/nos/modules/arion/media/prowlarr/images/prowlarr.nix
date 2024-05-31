pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:682517acf453df5dad8a2d41e34a4fa52643de69af0af03c67f8c07abcf0345a";
  sha256 = "17wgzk8hi5m07vsl7d6z546105w6a1f2j3dkb4b93n10zflmv4hn";
  finalImageName = "ghcr.io/linuxserver/prowlarr";
  finalImageTag = "latest";
}
