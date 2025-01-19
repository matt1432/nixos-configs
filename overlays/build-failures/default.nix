final: prev: {
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/wy/wyoming-faster-whisper/package.nix
  wyoming-faster-whisper = prev.wyoming-faster-whisper.overridePythonAttrs (o: {
    meta = {mainProgram = o.pname;} // o.meta;
  });
}
