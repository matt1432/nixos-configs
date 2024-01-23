{...}: {
  imports = [./options.nix];

  # TODO: update script
  services.pacemaker = {
    enable = true;

    resources = {};
  };
}
