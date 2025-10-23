final: prev: {
  # FIXME: https://pr-tracker.nelim.org/?pr=454716
  nextcloud-client = prev.nextcloud-client.overrideAttrs (o: rec {
    version = "4.0.0";
    src = final.fetchFromGitHub {
      owner = "nextcloud-releases";
      repo = "desktop";
      tag = "v${version}";
      hash = "sha256-IXX1PdMR3ptgH7AufnGKBeKftZgai7KGvYW+OCkM8jo=";
    };
  });
}
