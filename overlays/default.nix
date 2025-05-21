final: prev: {
  # pkgs
  openASAR = final.discord.override {withOpenASAR = true;};
  scripts = final.callPackage ../pkgs/scripts {};
}
