{...}: {
  services.ollama = {
    enable = true;
    acceleration = "cuda";

    host = "100.64.0.4";
    port = 11434;

    loadModels = ["fixt/home-3b-v3"];
  };
}
