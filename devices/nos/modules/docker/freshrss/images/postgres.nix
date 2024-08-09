pkgs:
pkgs.dockerTools.pullImage {
  imageName = "postgres";
  imageDigest = "sha256:b4d7cd7bd1bc275e8862271531e2180b6c3e9bd92f09e2f53f6c87836183235a";
  sha256 = "0391kqxi9yi2kkh8zm5q4fl4xsris68qzwvdqmpcycxr1dgpwqhj";
  finalImageName = "postgres";
  finalImageTag = "14";
}
