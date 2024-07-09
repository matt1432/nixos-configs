{pkgs, ...}: {
  services = {
    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = with pkgs; [
        (hplip.override {
          # FIXME: https://github.com/NixOS/nixpkgs/pull/325682
          python3Packages = python311Packages;
        })
      ];
    };
  };
}
