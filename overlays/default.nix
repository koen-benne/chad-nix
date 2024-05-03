final: prev: {
  # pkgs
  # grub-reboot-menu = final.callPackage ../pkgs/grub-reboot-menu { };
  jetbrains-mono-nerdfont = final.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
  nibar = final.callPackage ../pkgs/nibar { };
  scripts = final.callPackage ../pkgs/scripts { };
  sf-symbols = final.sf-symbols-minimal;
  sf-symbols-app = final.callPackage ../pkgs/sf-symbols { app = true; fonts = false; };
  sf-symbols-full = final.callPackage ../pkgs/sf-symbols { full = true; };
  sf-symbols-minimal = final.callPackage ../pkgs/sf-symbols { };
  # subfinder = final.callPackage ../pkgs/subfinder { };
}
