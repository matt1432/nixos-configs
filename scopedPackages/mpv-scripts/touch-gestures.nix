{
  # nix build inputs
  lib,
  buildLua,
  mkVersion,
  mpv-touch-gestures-src,
  ...
}:
buildLua {
  pname = "touch-gestures";
  version = mkVersion mpv-touch-gestures-src;

  src = mpv-touch-gestures-src;

  meta = {
    license = lib.licenses.gpl2;
    homepage = "https://github.com/christoph-heinrich/mpv-touch-gestures";
    description = ''
      Touch gestures for mpv.
    '';
  };
}
