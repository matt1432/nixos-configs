pkgs:
pkgs.dockerTools.pullImage {
  imageName = "vegardit/gitea-act-runner";
  imageDigest = "sha256:a69efce45a138217a87e24fe0197519a95ec60fc35bfcaffaced9fed5e86a1ec";
  sha256 = "05b5r4ncbx228cc3s4b4k5n9kh9krwh20r81lbpzdbyk3m8hjfw6";
  finalImageName = "vegardit/gitea-act-runner";
  finalImageTag = "dind-latest";
}
