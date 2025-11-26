{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  flask,
  pyyaml,
}:
buildPythonPackage rec {
  pname = "swagger-ui-py";
  version = "23.9.23";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RU7TpEE6EJ00VdpyYFlqTUQh8/LPApjTpmQ8UEfm6kE=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    flask
    pyyaml
  ];

  # The package includes pre-built swagger-ui assets, no build needed
  dontBuild = false;

  # Tests might require additional dependencies
  doCheck = false;

  pythonImportsCheck = [
    "swagger_ui"
  ];

  meta = with lib; {
    description = "Swagger UI for Python web frameworks";
    longDescription = ''
      swagger-ui-py is a Python package that bundles Swagger UI assets
      and provides utilities to serve them in Python web applications.
      It includes the complete Swagger UI interface for API documentation.
    '';
    homepage = "https://github.com/swagger-api/swagger-ui-py";
    license = licenses.asl20; # Apache License 2.0
    maintainers = with maintainers; [];
    platforms = platforms.all;
  };
}
