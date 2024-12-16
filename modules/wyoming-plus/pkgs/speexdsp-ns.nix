{
  fetchFromGitHub,
  python3Packages,
  speexdsp,
  swig,
  ...
}:
python3Packages.buildPythonApplication {
  pname = "speexdsp-ns";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "TeaPoly";
    repo = "speexdsp-ns-python";
    rev = "8af784a230e23f4eeaa4a58111774ad0864b1f0b";
    hash = "sha256-9IGhHZBlDYfGygB+fAdEDp7qeIEOWBsiLZAUFTVBxG0=";
  };

  nativeBuildInputs = [swig];
  propagatedBuildInputs = [speexdsp];
}
