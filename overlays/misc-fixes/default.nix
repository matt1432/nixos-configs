final: prev: {
  # FIXME: https://pr-tracker.nelim.org/?pr=439286
  wyoming-piper = prev.wyoming-piper.overridePythonAttrs (o: {
    pythonRelaxDeps = o.pythonRelaxDeps or [] ++ ["regex"];
  });
}
