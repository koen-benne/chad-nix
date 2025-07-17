{ lib
, buildPythonPackage
, fetchPypi
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "JSON-log-formatter";
  version = "0.5.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-exka5AVkaLryt0RcXOZRvZ7mt2tBYqR5p9hdtq4Cny0=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  # No runtime dependencies based on the PyPI page
  propagatedBuildInputs = [ ];

  doCheck = false; # No tests in the package

  meta = with lib; {
    description = "JSON formatter for Python logging";
    homepage = "https://pypi.org/project/JSON-log-formatter/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ]; # Add your name
  };
}

