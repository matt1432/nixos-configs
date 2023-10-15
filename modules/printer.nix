{ pkgs, ... }: {

  services = {
  # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = with pkgs; [
        hplip
      ];
    };
  };
}
