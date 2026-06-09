pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:c0a4335d4249b46102f64cf6fa27ffc3bddfd9138fac1e4ddf238afd37f02d1f";
  hash = "sha256-G+xxykJWU7OXUWnpERlSstH4IlHMDePfgXEgffQIjFo=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
