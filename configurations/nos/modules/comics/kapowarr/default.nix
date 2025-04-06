{mainUser, ...}: {
  imports = [./module.nix];

  services.kapowarr = {
    enable = true;
    port = 5676;
    urlBase = "/kapowarr";

    user = mainUser;
    group = "users";
  };
}
