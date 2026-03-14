{fetchFromGitHub, ...}: let
  dashboardIcons = fetchFromGitHub {
    owner = "homarr-labs";
    repo = "dashboard-icons";
    rev = "bde2ad3fba12e6049c828bae24a2da5f85d1c865";
    hash = "sha256-ixJixxFncCuKa8UVTfGPenzyxJ3hlxgO/YZ+f3gloLQ=";
  };
in ''
  mkdir -p $out/share/homepage/public/icons
  cp -r --no-preserve=mode ${dashboardIcons}/png/. $out/share/homepage/public/icons
  cp -r --no-preserve=mode ${dashboardIcons}/svg/. $out/share/homepage/public/icons
  cp ${dashboardIcons}/LICENSE $out/share/homepage/public/icons/
''
