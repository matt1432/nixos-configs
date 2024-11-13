pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/prowlarr";
  imageDigest = "sha256:7cd854daf61f7f2f68b8680850d86519409a61247e556ff41a3aae0e0cc3fb10";
  sha256 = "0qy2j4jl6ssjgr6kg5jy5rvpl72avqb9xfkavplr3bs6yk6xsvaf";
  finalImageName = imageName;
  finalImageTag = "latest";
}
