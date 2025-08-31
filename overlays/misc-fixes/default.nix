final: prev: {
  # FIXME: build failure with regex
  wyoming-piper = prev.wyoming-piper.overridePythonAttrs (o: {
    pythonRelaxDeps = o.pythonRelaxDeps or [] ++ ["regex"];
  });
}
