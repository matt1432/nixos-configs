{pkgs, ...} @ inputs: {
  bat = pkgs.callPackage ./bat.nix {inherit (inputs) bat-theme-src;};
  git = pkgs.callPackage ./git.nix {inherit (inputs) git-theme-src;};
  gtk = import ./gtk.nix {inherit (inputs) gtk-theme-src pkgs;};
  plymouth = pkgs.callPackage ./plymouth.nix {inherit (inputs) dracula-plymouth-src;};
  sioyek = pkgs.callPackage ./sioyek.nix {inherit (inputs) sioyek-theme-src;};
  wallpaper = pkgs.fetchurl (import ./wallpaper.nix);
  xresources = pkgs.callPackage ./xresources.nix {inherit (inputs) xresources-src;};
}
