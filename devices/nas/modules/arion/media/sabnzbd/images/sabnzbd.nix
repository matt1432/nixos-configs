pkgs:
pkgs.dockerTools.pullImage {
  imageName = "lscr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:c3a1f221f147d499838540f120503be733b395fec632f9289c2acb0586cf0451";
  sha256 = "1albix8cax9ncvrpng95hmxig7kaxplz8yczl7sij7df72vmh81i";
  finalImageName = "lscr.io/linuxserver/sabnzbd";
  finalImageTag = "latest";
}
