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
      # Networking
      dig.dnsutils
      mosh
      openssh
      rsync
      wget

      # Misc CLI stuff
      killall
      neofetch
      nix-output-monitor
      progress
      tree
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
