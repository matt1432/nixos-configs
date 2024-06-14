{pkgs, ...} @ inputs:
pkgs.lib.makeScope pkgs.newScope (drac: {
  bat = drac.callPackage ./bat.nix {
    inherit (inputs) bat-theme-src mkVersion;
  };

  git = drac.callPackage ./git.nix {
    inherit (inputs) git-theme-src mkVersion;
  };

  gtk = import ./gtk.nix {inherit (inputs) gtk-theme-src pkgs;};

  plymouth = drac.callPackage ./plymouth.nix {
    inherit (inputs) dracula-plymouth-src mkVersion;
  };

  sioyek = drac.callPackage ./sioyek.nix {
    inherit (inputs) sioyek-theme-src mkVersion;
  };

  wallpaper = drac.callPackage ./wallpaper.nix {};
})
