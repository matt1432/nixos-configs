pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:3b5f286a417dde5945504ef9156ff9436ffccf428048d7b52c1574c6fc752bb6";
  sha256 = "0w59mwbslf2zz8xfdkp1zaljnr0vjxd0bawkhxd6g08wyd8scszd";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
