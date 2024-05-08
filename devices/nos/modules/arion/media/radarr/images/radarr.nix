pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:1c2f2abbabd19c47549a4e7c3315402a3a4c37f141ba56cef3395ec6b292a015";
  sha256 = "0hw44rn2b7kxnd56h3h12ynvbi849pb8hr7i69fmj6skrgpm5gw3";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
