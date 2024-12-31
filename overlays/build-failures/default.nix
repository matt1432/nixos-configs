final: prev: {
  # FIXME: https://pr-tracker.nelim.org/?pr=357699
  nodejs_latest = prev.nodejs_22;

  # FIXME: https://pr-tracker.nelim.org/?pr=368790
  triton-llvm = prev.triton-llvm.override {
    buildTests = false;
  };

  # FIXME: https://github.com/NixOS/nixpkgs/issues/365156
  protonmail-desktop = final.callPackage ({
    lib,
    stdenv,
    fetchurl,
    makeWrapper,
    dpkg,
    electron,
    unzip,
  }: let
    mainProgram = "proton-mail";
    srcHashes = {
      universal-darwin = "sha256-6b+CNCvrkIA1CvSohSJZq/veZZNsA3lyhVv5SsBlJlw=";
      x86_64-linux = "sha256-v8ufnQQEqTT5cr7fq8Fozje/NDlBzaCeKIzE6yU/biE=";
    };
  in
    stdenv.mkDerivation rec {
      pname = "protonmail-desktop";
      version = "1.0.6";

      src = fetchurl {
        url =
          if stdenv.hostPlatform.isDarwin
          then "https://github.com/ProtonMail/inbox-desktop/releases/download/${version}/Proton.Mail-darwin-universal-${version}.zip"
          else "https://github.com/ProtonMail/inbox-desktop/releases/download/${version}/proton-mail_${version}_amd64.deb";
        sha256 =
          {
            x86_64-linux = srcHashes.x86_64-linux;
            x86_64-darwin = srcHashes.universal-darwin;
            aarch64-darwin = srcHashes.universal-darwin;
          }
          .${stdenv.hostPlatform.system}
          or (throw "unsupported system ${stdenv.hostPlatform.system}");
      };

      sourceRoot = lib.optionalString stdenv.hostPlatform.isDarwin ".";

      dontConfigure = true;
      dontBuild = true;

      nativeBuildInputs =
        [
          makeWrapper
        ]
        ++ lib.optional stdenv.hostPlatform.isLinux dpkg
        ++ lib.optional stdenv.hostPlatform.isDarwin unzip;

      installPhase = let
        darwin = ''
          mkdir -p $out/{Applications,bin}
          cp -r "Proton Mail.app" $out/Applications/
          makeWrapper $out/Applications/"Proton Mail.app"/Contents/MacOS/Proton\ Mail $out/bin/protonmail-desktop
        '';
        linux = ''
          runHook preInstall
          mkdir -p $out
          cp -r usr/share/ $out/
          cp -r usr/lib/proton-mail/resources/app.asar $out/share/
        '';
      in ''
        runHook preInstall

        ${
          if stdenv.hostPlatform.isDarwin
          then darwin
          else linux
        }

        runHook postInstall
      '';

      preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
        makeWrapper ${lib.getExe electron} $out/bin/${mainProgram} \
          --add-flags $out/share/app.asar \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
          --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
          --set-default ELECTRON_IS_DEV 0 \
          --inherit-argv0
      '';

      meta = {
        description = "Desktop application for Mail and Calendar, made with Electron";
        homepage = "https://github.com/ProtonMail/inbox-desktop";
        license = lib.licenses.gpl3Plus;
        platforms = [
          "x86_64-linux"
          "x86_64-darwin"
          "aarch64-darwin"
        ];
        sourceProvenance = [lib.sourceTypes.binaryNativeCode];
        inherit mainProgram;
      };
    }) {};
}
