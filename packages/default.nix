{
  inputs,
  mkVersion,
  ...
}: (final: prev: {
  selfPackages = {
    coloryou = final.callPackage ./coloryou {};

    gpu-screen-recorder = final.callPackage ./gpu-screen-recorder {
      inherit (inputs) gpu-screen-recorder-src;
    };

    homepage = final.callPackage ./homepage {};

    jmusicbot = final.callPackage ./jmusicbot {};

    komf = final.callPackage ./komf {
      inherit (inputs) komf-src;
    };

    libratbag = final.callPackage ./libratbag {
      inherit (inputs) libratbag-src;
    };

    librespot-auth = final.callPackage ./librespot-auth {};

    nbted = final.callPackage ./nbted {};

    pam-fprint-grosshack = final.callPackage ./pam-fprint-grosshack {};

    piper = final.callPackage ./piper {
      inherit (inputs) piper-src;
    };

    pokemon-colorscripts = final.callPackage ./pokemon-colorscripts {
      inherit (inputs) pokemon-colorscripts-src;
      inherit mkVersion;
    };

    protonhax = final.callPackage ./protonhax {};

    repl = final.callPackage ./repl {};

    some-sass-language-server = final.callPackage ./some-sass-language-server {};

    subscleaner = final.callPackage ./subscleaner {
      inherit (inputs) subscleaner-src;
    };

    trash-d = final.callPackage ./trash-d {
      inherit (inputs) trash-d-src;
    };

    whoogle-search = final.callPackage ./whoogle-search {};
  };
})
