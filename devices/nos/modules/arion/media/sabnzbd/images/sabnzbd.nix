pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:a051c4be8db68e7555aea3f3871f8f54f1f4c10692b381003a604c032310753a";
  sha256 = "03h0yvp9w56y44b6vs36899irj5f49ffabwygxcxj96kdnbg2s7y";
  finalImageName = "ghcr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
