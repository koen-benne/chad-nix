final: prev: {
  # pkgs
  jetbrains-mono-nerdfont = final.nerdfonts.override {fonts = ["JetBrainsMono"];};
  openASAR = final.discord.override {withOpenASAR = true;};
  nibar = final.callPackage ../pkgs/nibar {};
  scripts = final.callPackage ../pkgs/scripts {};
  # subfinder = final.callPackage ../pkgs/subfinder { };
}
