{pkgs, ...} @ inputs:
pkgs.lib.makeScope pkgs.newScope (drac: {
  bat = drac.callPackage ./bat.nix {inherit (inputs) bat-theme-src;};
  git = drac.callPackage ./git.nix {inherit (inputs) git-theme-src;};
  gtk = import ./gtk.nix {inherit (inputs) gtk-theme-src pkgs;};
  plymouth = drac.callPackage ./plymouth.nix {inherit (inputs) dracula-plymouth-src;};
  sioyek = drac.callPackage ./sioyek.nix {inherit (inputs) sioyek-theme-src;};
  wallpaper = pkgs.fetchurl (import ./wallpaper.nix);
})
