pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:f9ea18bfa4fad859e1ed38259d711da7ccad2c3516e875cec3351a57c859f571";
  hash = "sha256-ks++IsgVzGw+9/pwHohm/Vgt7UmPN6xvwHfR5x5UW2w=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
