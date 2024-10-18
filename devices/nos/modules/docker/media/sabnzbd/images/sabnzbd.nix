pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/linuxserver/sabnzbd";
  imageDigest = "sha256:ab4fc46cb5e2702f640b28bdc9b460c98b73a9898dd61f7068229f140c26409a";
  sha256 = "0zx1glxr3adwcd6migh8lal30aih9rzmlzkqzlz2vrad7j3i5h1y";
  finalImageName = imageName;
  finalImageTag = "latest";
}
