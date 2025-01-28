{
  writeShellApplication,
  ffmpeg-full,
  ...
}:
writeShellApplication {
  name = "convert-mkv";

  runtimeInputs = [ffmpeg-full];

  text = ''
    extension="$1"
    file="$2"

    new_file="''${file%."$extension"}.mkv"

    ffmpeg -i "$file" -c copy "$new_file" &&
    rm "$file"
  '';
}
