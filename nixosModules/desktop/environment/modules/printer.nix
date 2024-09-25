{pkgs, ...}: {
  config = {
    services = {
      # Enable CUPS to print documents.
      printing = {
        enable = true;

        drivers = builtins.attrValues {
          inherit
            (pkgs)
            hplip
            samsung-unified-linux-driver
            ;
        };
      };
    };
  };

  # For accurate stack trace
  _file = ./printer.nix;
}
