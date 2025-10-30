final: prev: {
  firefox-devedition = prev.firefox-devedition.overrideAttrs {
    disallowedRequisites = [];
  };
}
