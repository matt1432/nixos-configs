pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nextcloud";
  imageDigest = "sha256:ae06fc9821c30656c2181bfbb78084b97fe784ba5d864952e7295e077e4c8cb0";
  hash = "sha256-s12sbTfjoIOlqihgkOrItmXOp+3I4OV180v9Roa3k4g=";
  finalImageName = imageName;
  finalImageTag = "fpm";
}
