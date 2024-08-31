{pkgs, ...}: {
  config = {
    services = {
      # Enable CUPS to print documents.
      printing = {
        enable = true;

        drivers = [
          pkgs.hplip
        ];
      };
    };
  };

  # For accurate stack trace
  _file = ./printer.nix;
}
