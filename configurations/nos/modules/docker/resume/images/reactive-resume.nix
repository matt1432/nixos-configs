pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:5ca66890dc8c2f71026b3efe24b3a87b2ad4dcccad7d4eefb5de9052d07094cd";
  hash = "sha256-Fg0sSPaihtxJNCwQqdEmcKr+qkxinXhLd2kWsuC8mnU=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
