{
  lib,
  stdenv,
  fetchFromGitHub,
  libxkbcommon,
  pkg-config,
  meson,
  ninja,
  check,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libtsm";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "kmscon";
    repo = "libtsm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5Lv/Hb0FGWARk3Wv3IuAbtCDII7qOMmcZSmKTkgTEsc=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  buildInputs = [
    libxkbcommon
    check
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  meta = {
    description = "Terminal-emulator State Machine";
    homepage = "https://www.freedesktop.org/wiki/Software/kmscon/libtsm/";
    changelog = "https://github.com/kmscon/libtsm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ccicnce113424];
    platforms = lib.platforms.linux;
  };
})
