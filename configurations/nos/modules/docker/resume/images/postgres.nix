pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:3a82e1f56c8f0f5616a11103ac3d47e632c3938698946a7ad26da0df1334744a";
  hash = "sha256-npuoUAjLIl3Hrd3NZlo3lq988jnb9oeKy8PasrOdmg4=";
  finalImageName = imageName;
  finalImageTag = "latest";
}
