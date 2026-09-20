pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:abe47724e466aeab9a345d8e46a221c2fa8953c7848bb4a3bd9976a7199f8cf2";
  hash = "sha256-LTDHR/eRmiE1sXfyVz3cVge17zdrIa0OuuFlAqVHVVg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
