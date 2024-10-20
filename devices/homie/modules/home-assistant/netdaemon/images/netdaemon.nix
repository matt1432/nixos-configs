pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "netdaemon/netdaemon4";
  imageDigest = "sha256:c52ef7ad2252ea52b903c76f2c3e2772d574ebb600ebd1d13310af688b7f82ab";
  sha256 = "1lk6wc4k48i9biycj1wagbjziwg50fn29awmwlvayxpzh63b5qbg";
  finalImageName = imageName;
  finalImageTag = "24.42.0";
}
