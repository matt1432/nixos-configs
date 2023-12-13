{
  stdenv,
  meson,
  ninja,
  pkg-config,
  cmake,
  bash-completion,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "input-emulator";

  src = fetchFromGitHub {
    owner = "tio";
    repo = pname;
    rev = "6c35040e6fc4f65ce0519ee76d00d60490bcb987";
    sha256 = "sha256-Im0RADqRwlZ/RiZFSVp+HwnWoLdcpRp0Ej6RP0GY0+c=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cmake
    bash-completion
  ];
}
