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
  opforjellyfin = prev.stdenv.mkDerivation rec {
    pname = "opforjellyfin";
    version = "1.0.1";

    src = prev.fetchurl {
      url = "https://github.com/tissla/opforjellyfin/releases/download/v${version}/opfor-linux";
      sha256 = "1w6bm1j325nv964yg8w4hbnskv1gwdw1arhfy9fpp4pjn0w92i16";
    };

    nativeBuildInputs = with prev; [
      autoPatchelfHook
      makeWrapper
    ];

    buildInputs = with prev; [
      # C/C++ runtime libraries
      stdenv.cc.cc.lib # This provides libstdc++.so.6
      gcc.cc.lib # Alternative way to get libstdc++
      glibc # C standard library
    ];

    # Runtime dependencies
    propagatedBuildInputs = with prev; [
      git # Required for the program to function
    ];

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      install -D -m755 $src $out/bin/opfor-linux
      # Create a symlink with a shorter name
      ln -s $out/bin/opfor-linux $out/bin/opfor
      runHook postInstall
    '';

    postFixup = ''
      # Additional wrapping if needed for runtime dependencies
      # wrapProgram $out/bin/opfor-linux \
      #   --prefix PATH : ${prev.lib.makeBinPath [
        /*
        runtime dependencies
        */
      ]}
    '';

    meta = with prev.lib; {
      description = "opforjellyfin - A tool for Jellyfin";
      homepage = "https://github.com/tissla/opforjellyfin";
      license = licenses.unfree; # Update this based on actual license
      maintainers = []; # Add your info if desired
      platforms = platforms.linux;
    };
  };
}
