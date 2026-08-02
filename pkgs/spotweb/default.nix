{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spotweb";
  version = "unstable-2026-08-02";

  src = fetchFromGitHub {
    owner = "spotweb";
    repo = "spotweb";

    # Replace with a specific commit before committing this.
    rev = "master";
    hash = "sha256-dobRABB0Cq4v9+odMMXRwMcCNvxyQ5RE1Lcc9M+QPD4=";
  };

  dontConfigure = true;
  dontBuild = true;

  postPatch = ''
    # Spotweb normally expects both of these files directly next to its
    # application source. That cannot work from the read-only Nix store.
    #
    # The local NixOS module will instead create:
    #   /etc/spotweb/dbsettings.inc.php
    #   /etc/spotweb/ownsettings.php

    substituteInPlace lib/Bootstrap.php \
      --replace-fail \
        "file_exists(__DIR__.'/../dbsettings.inc.php')" \
        "file_exists('/etc/spotweb/dbsettings.inc.php')" \
      --replace-fail \
        "require __DIR__.'/../dbsettings.inc.php';" \
        "require '/etc/spotweb/dbsettings.inc.php';"

    substituteInPlace settings.php \
      --replace-fail \
        "file_exists(__DIR__.'/ownsettings.php')" \
        "file_exists('/etc/spotweb/ownsettings.php')" \
      --replace-fail \
        "require_once __DIR__.'/ownsettings.php';" \
        "require_once '/etc/spotweb/ownsettings.php';"

    # This is a legacy second override file. We do not plan to use it, but
    # redirect it as well so Spotweb never attempts to read from $out.
    substituteInPlace settings.php \
      --replace-fail \
        "file_exists(__DIR__.'/reallymyownsettings.php')" \
        "file_exists('/etc/spotweb/reallymyownsettings.php')" \
      --replace-fail \
        "require_once __DIR__.'/reallymyownsettings.php';" \
        "require_once '/etc/spotweb/reallymyownsettings.php';"

    # SpotWeb advertises imdbid lookup, but that doesn't actually seem to work.
    # Prowlarr can deal with this if we don't advertise it.
    substituteInPlace lib/page/SpotPage_newznabapi.php \
      --replace-fail \
        "supportedParams', 'q,imdbid'" \
        "supportedParams', 'q'"
  '';

  installPhase = ''
    runHook preInstall

    install -d "$out/share/spotweb"
    cp -a . "$out/share/spotweb"

    # These are not needed at runtime and should never accidentally be exposed.
    rm -rf "$out/share/spotweb/.git"
    rm -f "$out/share/spotweb/.rnd"

    runHook postInstall
  '';

  meta = {
    description = "Decentralised Usenet community based on the Spotnet protocol";
    homepage = "https://github.com/spotweb/spotweb";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
})
