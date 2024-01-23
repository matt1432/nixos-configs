{...}: {
  imports = [./options.nix];

  services.pacemaker = {
    enable = true;

    resources = {};
  };
}
