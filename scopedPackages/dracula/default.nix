{
  lib,
  pkgs,
  ...
} @ inputs:
lib.makeScope pkgs.newScope (drac: {
  bat = drac.callPackage ./bat {
    inherit (inputs) bat-theme-src mkVersion;
  };

  git = drac.callPackage ./git {
    inherit (inputs) git-theme-src mkVersion;
  };

  gtk = import ./gtk {inherit (inputs) gtk-theme-src pkgs;};

  plymouth = drac.callPackage ./plymouth {
    inherit (inputs) dracula-plymouth-src mkVersion;
  };

  sioyek = drac.callPackage ./sioyek {
    inherit (inputs) sioyek-theme-src mkVersion;
  };

  wallpaper = drac.callPackage ./wallpaper {};
})
