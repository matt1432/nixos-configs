final: prev: {
  # FIXME: https://github.com/NixOS/nixpkgs/issues/437024
  python3 = prev.python3.override {
    packageOverrides = pyfinal: pyprev: {
      lsprotocol = pyprev.lsprotocol.overridePythonAttrs (old: {
        version = "2023.0.1";

        src = final.fetchFromGitHub {
          owner = "microsoft";
          repo = "lsprotocol";
          tag = "2023.0.1";
          hash = "sha256-PHjLKazMaT6W4Lve1xNxm6hEwqE3Lr2m5L7Q03fqb68=";
        };
      });
    };
  };
  pythonPackages = final.python3.pkgs;
  python3Packages = final.python3.pkgs;
  python313Packages = final.python3.pkgs;

  # FIXME: build failure with regex
  wyoming-piper = prev.wyoming-piper.overridePythonAttrs (o: {
    pythonRelaxDeps = o.pythonRelaxDeps or [] ++ ["regex"];
  });
}
