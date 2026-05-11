pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:330beabe0909c908452c895bbecadf360ceacfd71ebcaea478fd2b4125e2a12e";
  hash = "sha256-PCvhG5IgcRvzOJQVhGcJEDq/odKSLabRlaOiu26Im9I=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
