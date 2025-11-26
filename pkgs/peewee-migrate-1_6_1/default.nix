{
  lib,
  buildPythonPackage,
  fetchPypi,
  peewee,
  click,
}:
buildPythonPackage rec {
  pname = "peewee-migrate";
  version = "1.6.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2rODfxxsMDIB9D1RquGAfLOWRKv4IsGqQ7uf7K2PYrw=";
  };

  propagatedBuildInputs = [
    peewee
    click
  ];

  # Disable tests since we're just backporting
  doCheck = false;

  meta = with lib; {
    description = "Simple migration engine for Peewee (version 1.6.1 for compatibility)";
    homepage = "https://github.com/klen/peewee_migrate";
    license = licenses.bsd3;
    maintainers = [];
  };
}
