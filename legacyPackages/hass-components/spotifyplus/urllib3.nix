# From nixpkgs 4c0061c983a2bcb888f5c478cfb7631ec1090c22
{
  lib,
  brotli,
  brotlicffi,
  buildPythonPackage,
  certifi,
  cryptography,
  fetchPypi,
  idna,
  isPyPy,
  mock,
  pyopenssl,
  pysocks,
  pytest-freezegun,
  pytest-timeout,
  pytestCheckHook,
  python-dateutil,
  tornado,
  trustme,
}:
buildPythonPackage rec {
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

  nativeCheckInputs = [
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

  passthru.optional-dependencies = {
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

  meta = with lib; {
    description = "Powerful, sanity-friendly HTTP client for Python";
    homepage = "https://github.com/shazow/urllib3";
    changelog = "https://github.com/urllib3/urllib3/blob/${version}/CHANGES.rst";
    license = licenses.mit;
  };
}
