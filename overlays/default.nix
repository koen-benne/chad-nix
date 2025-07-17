final: prev: {
  # pkgs
  scripts = final.callPackage ../pkgs/scripts {};
  python3 = prev.python3.override {
    packageOverrides = python-final: python-prev: {
      peewee-migrate-1_6_1 = python-final.callPackage ../pkgs/peewee-migrate-1_6_1 {};
      swagger-ui-py = python-final.callPackage ../pkgs/swagger-ui-py {};
      json-log-formatter = python-final.callPackage ../pkgs/json-log-formatter {};
      unmanic = python-final.callPackage ../pkgs/unmanic {};
    };
  };

  python3Packages = final.python3.pkgs;
}
