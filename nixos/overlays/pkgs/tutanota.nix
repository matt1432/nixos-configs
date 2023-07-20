{ lib
, pkgs
, stdenv
, appimageTools
, makeWrapper
, fetchurl
, libGL
, libsecret
, xorg
, ffmpeg
, curl
, alsa-lib
, udev
}:

let
  pname = "tutanota-desktop";
  version = "3.114.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/tutao/tutanota/releases/download/tutanota-desktop-release-${version}/tutanota-desktop-linux.AppImage";
    hash = "sha256-cWK95F3/zRyKt2fN/uN/dfDNnSiXgJq6mlGjtD3W7VY=";
  };

  extracted = appimageTools.extractType2 {
    inherit pname version src;
  };

in 

appimageTools.wrapType2 {
  inherit name src;

  profile = ''
    export LD_LIBRARY_PATH=${libGL}:${libsecret}:${ffmpeg}:${curl}:${alsa-lib}:${udev}:$LD_LIBRARY_PATH
  '';

  targetPkgs = pkgs: [ libGL libsecret ffmpeg curl alsa-lib udev ];

  extraInstallCommands = ''
    mkdir -p $out/bin $out/share/applications
    
    cp -r ${extracted}/* $out/

    ln -s $out/tutanota-desktop $out/bin/tutanota-desktop
    
    mv $out/tutanota-desktop.desktop $out/share/applications/
    substituteInPlace $out/share/applications/tutanota-desktop.desktop \
      --replace AppRun ${pname}
    
    source "${makeWrapper}/nix-support/setup-hook"
    wrapProgram $out/bin/${pname} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libsecret stdenv.cc.cc.lib ]}

    sed -i 's#exec -a "$0"#exec -a "$0" "${pkgs.steam-run}/bin/steam-run"#' "$out/bin/${pname}"
  '';
}

