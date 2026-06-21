pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/cleanuparr/cleanuparr";
  imageDigest = "sha256:a17be5104c2749cc8120e07dd63cb07fe8271f36fdb8f4a27ec46ddcf8581422";
  hash = "sha256-LDVxvzyzBVT9UwHhbbouYoEgmei8a3/Me8dVVEdNFSs=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
