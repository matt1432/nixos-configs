pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:328bd8cf4b64b81567def9de01a893fb819ab2a94a714a24c9f304995b5645c1";
  sha256 = "0391kqxi9yi2kkh8zm5q4fl4xsris68qzwvdqmpcycxr1dgpwqhj";
  finalImageName = "postgres";
  finalImageTag = "14";
}
