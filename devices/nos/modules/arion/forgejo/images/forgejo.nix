pkgs:
pkgs.dockerTools.pullImage {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:7918c661718554aefb5901f2c6336b12a1bed427f2b080ee732ca6cd0324f8fd";
  sha256 = "0rvncgami6p777qrlnblyxkjyjabk6npgjzq3isxw77gffvxvj9y";
  finalImageName = "codeberg.org/forgejo/forgejo";
  finalImageTag = "7.0.3";
}
