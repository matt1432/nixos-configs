pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:0498b67709f769fee36b1acf02f69e8d9981b051aa5b8200878d938bd537d39d";
  sha256 = "155bsh7v64xp0miaw173yhhandvgdy1qk34n7k3msp9x1ng13in3";
  finalImageName = imageName;
  finalImageTag = "latest";
}
