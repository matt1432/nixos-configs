pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:c60610599d681dc7ea0aa1a5edfc1637ff4b5fb062872aea1539d291c835c4b3";
  sha256 = "1mvxw60wqp5r4wwjijy286yvg6hwwfq3l10ah6hcmym1sh8p6ss6";
  finalImageName = imageName;
  finalImageTag = "latest";
}
