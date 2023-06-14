{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook
, gtk-layer-shell
, libpulseaudio
}:

rustPlatform.buildRustPackage {
  pname = "swayosd";
  version = "unstable-2023-05-09";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayOSD";
    rev = "c573f5ce94e2017d37b3dd3c2c1363bb1c6f82a3";
    hash = "sha256-cPom4dU+64TdCIi9D+GZN+EJltgXWy8fezEL1r9kUDo=";
  };

  cargoHash = "sha256-fkPpkXvq2ms6+Vt12cnsjKkbJdN2JgVrRxGRH9qaGD8=";

  nativeBuildInputs = [
    wrapGAppsHook
    pkg-config
  ];

  buildInputs = [
    gtk-layer-shell
    libpulseaudio
  ];

  meta = with lib; {
    description = "A GTK based on screen display for keyboard shortcuts";
    homepage = "https://github.com/ErikReider/SwayOSD";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.linux;
  };
}
