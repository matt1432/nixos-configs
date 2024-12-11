pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:18d7873c8b773c10944c475fe96ca8ae79186512d3c6f403bcbd4409c9c4acfc";
  sha256 = "07i9hx8vi8mki7p7gz3mszk4y4skvgakydip0428pwgsy42w54zk";
  finalImageName = imageName;
  finalImageTag = "latest";
}
