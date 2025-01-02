final: prev: {
  # pkgs
  jetbrains-mono-nerdfont = final.nerdfonts.override {fonts = ["JetBrainsMono"];};
  openASAR = final.discord.override {withOpenASAR = true;};
  scripts = final.callPackage ../pkgs/scripts {};
}
