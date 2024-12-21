{fetchFromGitHub, ...}: let
  dashboardIcons = fetchFromGitHub {
    owner = "walkxcode";
    repo = "dashboard-icons";
    rev = "be82e22c418f5980ee2a13064d50f1483df39c8c"; # Until 2024-07-21
    hash = "sha256-z69DKzKhCVNnNHjRM3dX/DD+WJOL9wm1Im1nImhBc9Y=";
  };
in ''
  mkdir -p $out/share/homepage/public/icons
  cp ${dashboardIcons}/png/* $out/share/homepage/public/icons
  cp ${dashboardIcons}/svg/* $out/share/homepage/public/icons
  cp ${dashboardIcons}/LICENSE $out/share/homepage/public/icons/
''
