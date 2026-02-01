{
  foldl,
  hasAttr,
  isAttrs,
  isList,
  mergeAttrsWithFunc,
  unique,
  ...
}: {
  inherit (import ../../inputs/lib.nix) recursiveUpdateList;

  throws = x: !(builtins.tryEval x).success;

  hasVersion = x: isAttrs x && hasAttr "version" x;

  mergeAttrsList = list:
    foldl (mergeAttrsWithFunc (a: b:
      if isList a && isList b
      then unique (a ++ b)
      else b)) {}
    list;
}
