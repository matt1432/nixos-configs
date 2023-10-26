final: prev: {
  vencord = prev.vencord.overrideAttrs (oldAttrs: rec {

    src = prev.fetchFromGitHub {
      owner = "Vendicated";
      repo = "Vencord";
      rev = "ffe6bb1c5d4191cad35a1bdcb84695e886ff4528";
      hash = "sha256-t4+8ybPzqcCtTSukBBgvbD7HiKG4K51WPVnJg0RQbs8=";
    };
  });
}

