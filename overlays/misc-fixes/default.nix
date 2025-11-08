final: prev: {
  firefox-devedition = prev.firefox-devedition.overrideAttrs {
    disallowedRequisites = [];
  };

  # FIXME: https://pr-tracker.nelim.org/?pr=454074
  lutris-unwrapped = prev.lutris-unwrapped.override {
    moddb = prev.python3Packages.moddb.override {
      pyrate-limiter = prev.python3Packages.pyrate-limiter.overridePythonAttrs {
        doCheck = false;
      };
    };
  };
}
