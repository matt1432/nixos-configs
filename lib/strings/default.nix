{
  concatStrings,
  stringToCharacters,
  substring,
  tail,
  toUpper,
  ...
}: {
  mkVersion = src: "0.0.0+" + src.shortRev or "dirty";

  capitalise = str: (toUpper (substring 0 1 str) + (concatStrings (tail (stringToCharacters str))));
}
