{
  pkgs,
  curseforge-server-downloader-src,
  pam-fprint-grosshack-src,
  pokemon-colorscripts-src,
  ...
} @ inputs: {
  coloryou = pkgs.callPackage ./coloryou {};

  curseforge-server-downloader = pkgs.callPackage ./curseforge-server-downloader {
    inherit curseforge-server-downloader-src;
  };

  dracula = import ./dracula inputs;

  pam-fprint-grosshack = pkgs.callPackage ./pam-fprint-grosshack {
    inherit pam-fprint-grosshack-src;
  };

  pokemon-colorscripts = pkgs.callPackage ./pokemon-colorscripts {
    inherit pokemon-colorscripts-src;
  };

  repl = pkgs.callPackage ./repl {};
}
