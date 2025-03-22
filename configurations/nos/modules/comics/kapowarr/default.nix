{mainUser, ...}: {
  imports = [./module.nix];

  services.kapowarr = {
    enable = true;
    port = 5676;

    user = mainUser;
    group = "users";
  };
}
