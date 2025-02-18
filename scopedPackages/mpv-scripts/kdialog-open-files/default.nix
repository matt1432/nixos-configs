{
  # nix build inputs
  lib,
  buildLua,
  fetchurl,
  ...
}:
buildLua rec {
  pname = "zenity-open-files";
  version = "0.0.0";

  unpackPhase = ":";
  src = fetchurl {
    url = "https://gist.githubusercontent.com/ntasos/d1d846abd7d25e4e83a78d22ee067a22/raw/b23b20e830bba024836f8b09412000658edee95c/kdialog-open-files.lua";
    hash = "sha256-qJ/Myx0mdaRsWWd+4Mk1/SUSSI/uqQdg/vLZo2pkEwA=";
  };
  scriptPath = "${src}";

  meta = {
    license = lib.licenses.unlicense;
    homepage = "https://gist.github.com/ntasos/d1d846abd7d25e4e83a78d22ee067a22";
    description = ''
      Use KDE KDialog to add files to playlist, subtitles to playing video or open URLs.
      Based on 'mpv-open-file-dialog' <https://github.com/rossy/mpv-open-file-dialog>.
    '';
  };
}
