pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:3329fbf778701cf53703b342b3a84da31caafec970ef9310be5723dd057666dc";
  sha256 = "1k7ygdj46n3bxmd4sypia6y1a16ljfda9w74jas3kj4rc3n9hijk";
  finalImageName = imageName;
  finalImageTag = "latest";
}
