pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:c0fddfc04075e4198cc8e075fe6a1182984a5a7d5951c3a3c39b7fba2f10fbce";
  hash = "sha256-i6cJtoN07qan56Sb9j8qJl58AHKj4s0cZQoyr+ZU/mE=";
  finalImageName = imageName;
  finalImageTag = "16";
}
