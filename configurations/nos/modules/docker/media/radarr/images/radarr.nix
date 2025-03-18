pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:23677e1cb09bd957796f4521748f0eff9eb65d883949c10442635eabe64b750a";
  hash = "sha256-GHammLG9pc77k59pF1PBA2z/sMre+voES2YgbQe01Fg=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
