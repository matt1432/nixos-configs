{
  fcft,
  fetchFromGitea,
  ...
}:
fcft.overrideAttrs (o: rec {
  version = "3.3.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = o.pname;
    rev = version;
    hash = "sha256-spK75cT6x0rHcJT2YxX1e39jvx4uQKL/b4CHO7bon4s=";
  };
})
