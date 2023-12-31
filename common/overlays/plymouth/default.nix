{plymouth-src, ...}: (final: prev: {
  plymouth = prev.plymouth.overrideAttrs (o: {
    version = plymouth-src.rev;
    src = plymouth-src;
  });
})
