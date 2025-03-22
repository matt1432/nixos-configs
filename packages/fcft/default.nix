{
  # nix build inputs
  fetchFromGitea,
  # deps
  fcft,
  ...
}:
fcft.overrideAttrs (o: rec {
  version = "3.3.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = o.pname;
    rev = version;
    hash = "sha256-qgNNowWQhiu6pr9bmWbBo3mHgdkmNpDHDBeTidk32SE=";
  };
})
