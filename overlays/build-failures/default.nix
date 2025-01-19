final: prev: {
  # FIXME: https://pr-tracker.nelim.org/?pr=357699
  nodejs_latest = prev.nodejs_22;

  wyoming-faster-whisper = prev.wyoming-faster-whisper.overridePythonAttrs (o: {
    meta = {mainProgram = o.pname;} // o.meta;
  });
}
