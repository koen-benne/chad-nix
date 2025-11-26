{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  flask,
  flask-migrate,
  flask-sqlalchemy,
  alembic,
  sqlalchemy,
  requests,
  peewee,
  peewee-migrate-1_6_1,
  swagger-ui-py,
  tornado,
  marshmallow,
  schedule,
  importlib-metadata,
  ffmpeg-full,
  makeWrapper,
  psutil,
  git,
  json-log-formatter,
  requests-toolbelt,
  nodejs_20,
  buildNpmPackage,
  fetchFromGitHub,
}: let
  # Build the frontend from the separate repository (master branch)
  unmanic-frontend = buildNpmPackage rec {
    pname = "unmanic-frontend";
    version = "unstable-2025-01-17";

    src = fetchFromGitHub {
      owner = "Unmanic";
      repo = "unmanic-frontend";
      rev = "master";
      hash = "sha256-vDbP2Zd5cmQWvp0vjrUKnhbaB0ypEZvz77cFSVu8BLI=";
    };

    # Frontend repo root should have package.json with Quasar
    sourceRoot = "${src.name}";

    nativeBuildInputs = [nodejs_20];

    npmDepsHash = "sha256-BjF2gKv8Ty4Bhc//nR7ecS0/Mdctm8/WOiRhFn+dEHc=";

    # Quasar builds differently than regular Vue
    buildPhase = ''
      runHook preBuild

      # Quasar uses 'quasar build' command typically
      # But let's check what scripts are available first
      echo "Available npm scripts:"
      cat package.json | grep -A 10 '"scripts"'

      # Try the build command (adapt based on what you find in package.json)
      npm run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      echo "Creating output directory: $out"
      mkdir --version
      mkdir -p $out

      echo "Contents of dist/spa:"
      ls -la dist/spa/

      echo "Copying from dist/spa/ to $out/"
      cp -r dist/spa/* $out/

      echo "Final output contents:"
      ls -la $out/

      runHook postInstall
    '';
    meta = with lib; {
      description = "Unmanic web frontend (Vue.js + Quasar)";
      license = licenses.gpl3Only;
    };
  };
in
  buildPythonPackage rec {
    pname = "unmanic";
    version = "0.3.0";
    format = "setuptools";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-CEWBu39O/y2nvoOerj6SEG4YI4nRgH5sWXvGUdZ6q7U=";
    };

    nativeBuildInputs = [
      setuptools
      wheel
      makeWrapper
      git
    ];

    propagatedBuildInputs = [
      flask
      flask-migrate
      flask-sqlalchemy
      alembic
      sqlalchemy
      requests
      peewee
      peewee-migrate-1_6_1
      swagger-ui-py
      tornado
      marshmallow
      schedule
      importlib-metadata
      psutil
      json-log-formatter
      requests-toolbelt
    ];

    buildInputs = [
      ffmpeg-full
    ];

    postPatch = ''
      # Fix version file if it contains UNKNOWN
      if [ -f unmanic/version ] && grep -q "UNKNOWN" unmanic/version; then
        echo '{"short": "${version}", "long": "${version}"}' > unmanic/version
      fi

      # Skip frontend build - using separate Quasar frontend
      substituteInPlace setup.py \
        --replace-warn "self.run_command('build-frontend')" "pass  # Frontend built from separate Quasar repo"
    '';

    preBuild = ''
      export HOME=$TMPDIR
      export npm_config_cache=$TMPDIR/npm-cache
      export npm_config_userconfig=$TMPDIR/.npmrc
    '';

    postInstall = ''
      echo "=== UNMANIC MAIN PACKAGE POST-INSTALL ==="
      echo "Finding Python installation directory..."

      # Find the actual Python site-packages directory
      PYTHON_SITES=$(find "$out" -path "*/site-packages" -type d)
      echo "Found site-packages directories: $PYTHON_SITES"

      if [ -z "$PYTHON_SITES" ]; then
        echo "No site-packages found. Contents of $out/lib:"
        ls -la "$out/lib/" || echo "No lib directory exists"
        exit 1
      fi

      # Use the first (likely only) site-packages directory found
      SITE_PACKAGES=$(echo "$PYTHON_SITES" | head -1)
      echo "Using site-packages: $SITE_PACKAGES"

      # Create the public directory in the correct location
      PUBLIC_DIR="$SITE_PACKAGES/unmanic/webserver/public"
      echo "Creating public directory: $PUBLIC_DIR"
      mkdir -p "$PUBLIC_DIR"

      # Copy frontend assets
      echo "Copying frontend from ${unmanic-frontend}"
      cp -r ${unmanic-frontend}/* "$PUBLIC_DIR/"

      echo "Frontend installation complete!"

      wrapProgram "$out/bin/unmanic" \
        --prefix PATH : ${lib.makeBinPath [ffmpeg-full]}
    '';

    doCheck = false;

    meta = with lib; {
      description = "Library Optimiser - A web-based tool for optimizing your media library";
      longDescription = ''
        Unmanic is a simple tool for optimising your file library.
        You can use it to convert your files into a single, uniform format,
        manage file movements based on timestamps, or execute custom commands
        against a file based on its file size.
      '';
      homepage = "https://github.com/Unmanic/unmanic";
      changelog = "https://github.com/Unmanic/unmanic/releases/tag/${version}";
      license = licenses.gpl3Only;
      maintainers = with maintainers; [];
      platforms = platforms.linux;
      mainProgram = "unmanic";
    };
  }
