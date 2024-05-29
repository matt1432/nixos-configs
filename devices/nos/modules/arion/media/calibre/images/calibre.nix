pkgs:
pkgs.dockerTools.pullImage {
  imageName = "ghcr.io/linuxserver/calibre";
  imageDigest = "sha256:c429ecd5eb61b28702b140e1a92b81150d1fd34800946215f115da93cf6bb6ea";
  sha256 = "1rpaj5mcix7jc8hbabfkssf5gqbwvpzjkvblmj8wsd0b9vc3qf29";
  finalImageName = "ghcr.io/linuxserver/calibre";
  finalImageTag = "latest";
}
