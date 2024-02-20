# https://discourse.nixos.org/t/in-overlays-when-to-use-self-vs-super/2968/12

self: super: {
  # pkgs
  # grub-reboot-menu = self.callPackage ../pkgs/grub-reboot-menu { };
  neovim-nightly = self.callPackage ../pkgs/neovim-nightly { };
  jetbrains-mono-nerdfont = self.nerdfonts.override { fonts = [ "JetBrainsMonoNL" ]; };
  nibar = self.callPackage ../pkgs/nibar { };
  scripts = self.callPackage ../pkgs/scripts { };
  sf-symbols = self.sf-symbols-minimal;
  sf-symbols-app = self.callPackage ../pkgs/sf-symbols { app = true; fonts = false; };
  sf-symbols-full = self.callPackage ../pkgs/sf-symbols { full = true; };
  sf-symbols-minimal = self.callPackage ../pkgs/sf-symbols { };
  # subfinder = self.callPackage ../pkgs/subfinder { };
}
