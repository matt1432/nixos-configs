pkgs:
pkgs.dockerTools.pullImage {
  imageName = "codeberg.org/forgejo/forgejo";
  imageDigest = "sha256:f3ec5c63038cf2ce31a71e50e48b24c334ba0a5233808d1a5a60d45203f84f02";
  sha256 = "1s6kw4kj7yhl57nzvny8w5d9y8ni0r7h9a1d0wjlqkvz9lxmhvmv";
  finalImageName = "codeberg.org/forgejo/forgejo";
  finalImageTag = "8.0.0";
}
