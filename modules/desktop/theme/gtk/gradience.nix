{pkgs, ...}: {
  # TODO: look into alternatives for gradience
  gradience = rec {
    # https://github.com/V-Mann-Nick/nix-home-manager/blob/main/gnome/theme.nix
    package = pkgs.python3Packages.buildPythonApplication {
      pname = "gradience";
      version = "0.8.0-beta1";

      src = pkgs.fetchgit {
        url = "https://github.com/GradienceTeam/Gradience.git";
        rev = "06b83cee3b84916ab9812a47a84a28ca43c8e53f";
        sha256 = "sha256-gdY5QG0STLHY9bw5vI49rY6oNT8Gg8oxqHeEbqM4XfM=";
        fetchSubmodules = true;
      };

      format = "other";
      dontWrapGApps = true;

      patches = [
        (pkgs.fetchpatch {
          url = "https://github.com/V-Mann-Nick/nix-home-manager/raw/e68c661f21bf17323f8f0657f3af06c7f837cc07/gnome/gradience.patch";
          hash = "sha256-CcOd5KXjSSwYan8MwIJ4SBmmMXriBlOLYk5XFADLf6c=";
        })
      ];

      nativeBuildInputs = with pkgs; [
        appstream-glib
        blueprint-compiler
        desktop-file-utils
        gettext
        glib
        gobject-introspection
        meson
        ninja
        pkg-config
        wrapGAppsHook4
        sassc
      ];

      buildInputs = with pkgs; [
        glib-networking
        libadwaita
        libportal
        libportal-gtk4
        librsvg
        libsoup_3
      ];

      propagatedBuildInputs = with pkgs.python3Packages; [
        anyascii
        jinja2
        lxml
        material-color-utilities
        pygobject3
        svglib
        yapsy
        packaging
        libsass
      ];

      preFixup = ''
        makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
      '';

      meta = with pkgs.lib; {
        homepage = "https://github.com/GradienceTeam/Gradience";
        description = "Customize libadwaita and GTK3 apps (with adw-gtk3)";
        license = licenses.gpl3Plus;
        maintainers = with maintainers; [foo-dogsquared];
      };
    };

    # Stub the gnome-shell binary to satisfy the check without downloading Gnome
    gnomeShellStub = pkgs.writeShellScriptBin "gnome-shell" ''
      echo "GNOME Shell 45.2"
    '';

    presets = pkgs.fetchFromGitHub {
      owner = "GradienceTeam";
      repo = "Community";
      rev = "b3628d28164d91b3be1cc4736cd77a19c5da4d74";
      hash = "sha256-tpS6LpPKedPBvI51bD/g299nYM7gY8C1+AmGza1FJ4w=";
    };

    build = pkgs.stdenv.mkDerivation {
      name = "gradience-build";
      phases = ["buildPhase" "installPhase"];
      nativeBuildInputs = [gnomeShellStub];
      buildPhase = ''
        export HOME=$TMPDIR
        export XDG_CURRENT_DESKTOP=GNOME
        mkdir -p $HOME/.config/presets
        ${package}/bin/gradience-cli apply -p "${presets}/curated/dracula-dark.json" --gtk both
        ${package}/bin/gradience-cli gnome-shell -p "${presets}/curated/dracula-dark.json" -v dark
      '';
      installPhase = ''
        mkdir -p $out
        cp -r .config/gtk-4.0 $out/
        cp -r .config/gtk-3.0 $out/
        cp -r .local/share/themes/gradience-shell $out/
      '';
    };

    shellTheme = "gradience-shell";
  };
}
