pkgs:
pkgs.dockerTools.pullImage {
  imageName = "rssbridge/rss-bridge";
  imageDigest = "sha256:f64dc2fa2c81c0930a447cd937e965d7bb6443c4f09883375f60c28ddb7d1883";
  sha256 = "0shdpj2whs0a8k4537a7gpdsf1v7iwbh8hvcj3vz25wfm4dvrg79";
  finalImageName = "rssbridge/rss-bridge";
  finalImageTag = "latest";
}
