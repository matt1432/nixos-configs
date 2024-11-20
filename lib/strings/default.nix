{
  concatStringsSep,
  stringToCharacters,
  substring,
  tail,
  toUpper,
  ...
}: {
  mkVersion = src: "0.0.0+" + src.shortRev;
  capitalise = str: (toUpper (substring 0 1 str) + (concatStringsSep "" (tail (stringToCharacters str))));
}
