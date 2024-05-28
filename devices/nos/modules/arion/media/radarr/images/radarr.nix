pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/radarr";
  imageDigest = "sha256:7c409b0b64358ac1b0df27b1ce27e0c5ea3aa22f1cbf2362914b846bffa8efdf";
  sha256 = "18lrmxfz7b222n8lrx9pmahrz7vss46fkfk62rxdk9y7nnk45f60";
  finalImageName = "ghcr.io/linuxserver/radarr";
  finalImageTag = "latest";
}
