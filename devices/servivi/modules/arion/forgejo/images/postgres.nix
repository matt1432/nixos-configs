pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:1b8d18a565774e1734ea11ac1d4485d3eb168718f08c85dc2e24aeb16316249c";
  sha256 = "05m8lmgly87cszg5iiv7c0gkz72bpdnh0kpp8zp91p32vyl225px";
  finalImageName = "postgres";
  finalImageTag = "14";
}
