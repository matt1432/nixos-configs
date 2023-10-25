final: prev: {
  vencord = prev.vencord.overrideAttrs (oldAttrs: rec {

    src = prev.fetchFromGitHub {
      owner = "Vendicated";
      repo = "Vencord";
      rev = "3bd657611cbc6b3cf3142ae59c39713922d167df";
      hash = "sha256-fbYHfyPYN7LH9NlOpeEa10rA9LEibhxj9ZHmOZabETc=";
    };
  });
}

