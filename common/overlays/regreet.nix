{pkgs, ...}: {
  programs.regreet = {
    package = pkgs.greetd.regreet.overrideAttrs (self: super: rec {
      version = "0.1.1-patched";
      src = pkgs.fetchFromGitHub {
        owner = "rharish101";
        repo = "ReGreet";
        rev = "61d871a0ee5c74230dfef8100d0c9bc75b309203";
        hash = "sha256-PkQTubSm/FN3FXs9vBB3FI4dXbQhv/7fS1rXkVsTAAs=";
      };
      cargoDeps = super.cargoDeps.overrideAttrs (_: {
        inherit src;
        outputHash = "sha256-dR6veXCGVMr5TbCvP0EqyQKTG2XM65VHF9U2nRWyzfA=";
      });

      # temp fix until https://github.com/rharish101/ReGreet/issues/32 is solved
      patches = [./patches/regreet.patch];
    });
  };
}
