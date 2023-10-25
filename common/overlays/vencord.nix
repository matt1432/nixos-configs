final: prev: {
  vencord = prev.vencord.overrideAttrs (oldAttrs: rec {

    src = prev.fetchFromGitHub {
      owner = "Vendicated";
      repo = "Vencord";
      rev = "70943455161031d63a4481249d14833afe94f5a5";
      hash = "sha256-i/n7qPQ/dloLUYR6sj2fPJnvvL80/OQC3s6sOqhu2dQ=";
    };
  });
}

