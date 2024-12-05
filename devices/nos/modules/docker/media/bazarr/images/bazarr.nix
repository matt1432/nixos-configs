pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/bazarr";
  imageDigest = "sha256:be98501c48d98eec67a3269cacf884eb122b884d0775cdb8ee9a03947ef2b493";
  sha256 = "1k49h4wglg3ikmnqywpjfznvbj0j31h58y88i485wpgrvrqv64mh";
  finalImageName = imageName;
  finalImageTag = "latest";
}
