pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:3c856bdd10f7f0035ef7812e774e64023af7b7d609c29e32177320e11039974f";
  sha256 = "0yq622mr43ymp8jrklk5s8xajj5hxk50dxjs3719pna4gc055gzz";
  finalImageName = imageName;
  finalImageTag = "dind-latest";
}
