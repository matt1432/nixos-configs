{
  pkgs,
  self,
  ...
}: {
  home.packages =
    (with self.packages.${pkgs.system}; [
      pokemon-colorscripts
      repl
    ])
    ++ (with pkgs.nodePackages; [
      undollar
    ])
    ++ (with pkgs; [
      dig.dnsutils
      dracula-theme
      imagemagick
      killall
      mosh
      neofetch
      nix-output-monitor
      openssh
      progress
      rsync
      tree
      unzip
      usbutils
      wget
      zip
    ])
    ++ [
      # This could help as well: nix derivation show -r /run/current-system
      (pkgs.writeShellApplication {
        name = "listDerivs";
        text = ''
          nix-store --query --requisites /run/current-system | cut -d- -f2- | sort -u
        '';
      })
    ];
}
