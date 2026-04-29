pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "ghcr.io/amruthpillai/reactive-resume";
  imageDigest = "sha256:1e0cce61586d1a10018e346bf5a839169eb86467303eef6c9b53e0994efdf7b3";
  hash = "sha256-HBHeLigZzBcNGThgAZO+VCPCyX2VG7Ot5GGKo2DBX7M=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
