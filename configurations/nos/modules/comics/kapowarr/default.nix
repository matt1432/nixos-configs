{kapowarr-react, mainUser, ...}: {
  imports = [kapowarr-react.nixosModules.default];

  services.kapowarr-react = {
    enable = true;
    port = 5676;
    urlBase = "/kapowarr";

    user = mainUser;
    group = "users";
  };
}
