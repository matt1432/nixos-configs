{
  inputs,
  mkVersion,
  ...
}: (final: prev: {
  selfPackages = {
    coloryou = final.python3Packages.callPackage ./coloryou {};

    fcft = final.callPackage ./fcft {};

    gpu-screen-recorder = final.callPackage ./gpu-screen-recorder/gpu-screen-recorder.nix {
      inherit (inputs) gpu-screen-recorder-src;
    };
    gsr-kms-server = final.callPackage ./gpu-screen-recorder/gsr-kms-server.nix {
      inherit (inputs) gpu-screen-recorder-src;
    };

    homepage = final.callPackage ./homepage {};

    jmusicbot = final.callPackage ./jmusicbot {};

    kapowarr = import ./kapowarr final;

    komf = final.callPackage ./komf {};

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

    proton-ge-latest = final.callPackage ./proton-ge-latest {};

    protonhax = final.callPackage ./protonhax {};

    repl = final.callPackage ./repl {};

    some-sass-language-server = final.callPackage ./some-sass-language-server {};

    subscleaner = final.callPackage ./subscleaner {
      inherit (inputs) poetry2nix subscleaner-src;
    };

    trash-d = final.callPackage ./trash-d {
      inherit (inputs) trash-d-src;
    };

    urllib3 = final.callPackage ./urllib3 {};
  };
})
