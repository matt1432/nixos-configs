pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "quay.io/vaultwarden/server";
  imageDigest = "sha256:a66735efe15d3a7ea63b5b3fe6913058756771349f6056e1be1ab7b4ef244b21";
  hash = "sha256-kruvO6o9K3dZ+TZ30PFHTX9RtgftuQWgAdrGzAuJBbw=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
