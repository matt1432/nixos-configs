pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "nginx";
  imageDigest = "sha256:b34848eff6db786b6b1282d3a9c3fd0b5563dfb6d261df4923378b419e0d24f0";
  hash = "sha256-lmnSMKNHQpMd3qeC1VwpJo82XopaAyEgA+ENLKQCf60=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
