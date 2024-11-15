pkgs:
pkgs.dockerTools.pullImage rec {
  imageName = "postgres";
  imageDigest = "sha256:846079648cd9ac5dbf977aa7ee68d7e57e8ed1e368d88b54298e3b8e96a23d88";
  sha256 = "0w59mwbslf2zz8xfdkp1zaljnr0vjxd0bawkhxd6g08wyd8scszd";
  finalImageName = imageName;
  finalImageTag = "15-alpine";
}
