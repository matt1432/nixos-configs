# From nixpkgs 4c0061c983a2bcb888f5c478cfb7631ec1090c22
{
  # nix build inputs
  lib,
  python3Packages,
  fetchPypi,
  ...
}:
python3Packages.buildPythonPackage rec {
  pname = "urllib3";
  version = "1.26.16";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jxNfZQJ1a95rKpsomJ31++h8mXDOyqaQQe3M5/BYmxQ=";
  };

  propagatedBuildInputs =
    passthru.optional-dependencies.brotli
    ++ passthru.optional-dependencies.socks;

  nativeCheckInputs = with python3Packages; [
    python-dateutil
    mock
    pytest-freezegun
    pytest-timeout
    pytestCheckHook
    tornado
    trustme
  ];

  doCheck = false;

  preCheck = ''
    export CI # Increases LONG_TIMEOUT
  '';

  pythonImportsCheck = [
    "urllib3"
  ];

  passthru.optional-dependencies = with python3Packages; {
    brotli =
      if isPyPy
      then [
        brotlicffi
      ]
      else [
        brotli
      ];
    secure = [
      certifi
      cryptography
      idna
      pyopenssl
    ];
    socks = [
      pysocks
    ];
  };

  meta = {
    license = lib.licenses.mit;
    homepage = "https://github.com/shazow/urllib3";
    changelog = "https://github.com/urllib3/urllib3/blob/${version}/CHANGES.rst";
    description = ''
      Powerful, sanity-friendly HTTP client for Python.
    '';
  };
}
