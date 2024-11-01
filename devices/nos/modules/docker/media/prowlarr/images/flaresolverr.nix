pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "21hsmw/flaresolverr";
  imageDigest = "sha256:21ade52a9dc85c1bc1592ccc994e41f3365a4603b3ca4a11328583aa6e99ace1";
  sha256 = "0yws6hmhf4hips767bx7rc3mzsnwnifs38ii7n6m8466sm3sw2kb";
  finalImageName = imageName;
  finalImageTag = "nodriver";
}
