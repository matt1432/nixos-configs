pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:816cf7d06ec33116c8f54cf14197085be89f25291686229485ee7d53a785b901";
  hash = "sha256-joyvYK1DoMzrtDwz7FlXO9dNTNey5z8+sCqocTsucCA=";
  finalImageName = imageName;
  finalImageTag = "14";
}
