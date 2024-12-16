{pkgs, ...}:
pkgs.writeShellApplication {
  name = "convertMkv";

  runtimeInputs = builtins.attrValues {
    inherit
      (pkgs)
      ffmpeg-full
      ;
  };

  text = ''
    extension="$1"
    file="$2"

    new_file="''${file%."$extension"}.mkv"

    ffmpeg -i "$file" -c copy "$new_file" &&
    rm "$file"
  '';
}
