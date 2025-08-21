final: prev: {
  # pkgs
  scripts = final.callPackage ../pkgs/scripts {};
  python3 = prev.python3.override {
    packageOverrides = python-final: python-prev: {
      peewee-migrate-1_6_1 = python-final.callPackage ../pkgs/peewee-migrate-1_6_1 {};
      swagger-ui-py = python-final.callPackage ../pkgs/swagger-ui-py {};
      json-log-formatter = python-final.callPackage ../pkgs/json-log-formatter {};
      unmanic = python-final.callPackage ../pkgs/unmanic {};
      md2confluence = python-final.callPackage ../pkgs/md2confluence {};
    };
  };
  python3Packages = final.python3.pkgs;
  jellyfin-web = prev.jellyfin-web.overrideAttrs (finalAttrs: previousAttrs: {
    installPhase = ''
      runHook preInstall

      # this is the important line
      sed -i "s#</head>#<script src=\"configurationpage?name=skip-intro-button.js\"></script></head>#" dist/index.html

      mkdir -p $out/share
      cp -a dist $out/share/jellyfin-web

      runHook postInstall
    '';
  });
}
