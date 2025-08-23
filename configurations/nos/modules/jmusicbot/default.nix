{mainUser, self, ...}: {
  imports = [self.nixosModules.jmusicbot];

  services.jmusicbot = {
    defaultUser = mainUser;
    defaultGroup = mainUser;

    instances = {
      be.enable = true;
      br.enable = true;
    };
  };
}
