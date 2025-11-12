# TODO: implement nwg-displays
{
  config,
  lib,
  pkgs,
  sys,
  inputs,
  ...
}: let
  inherit (lib) mkIf optionalString;
  scripts = ./scripts;
  
  # Import shared config
  sharedConfig = import ./config.nix;
  
  # Get appropriate browser command and packages based on context
  browserCmd = if sys ? networking then "zen" else "${nixGLPackage}/bin/nixGL zen";
  
  # NixGL setup for standalone home-manager mode
  nixGLPackage = 
    if (sys ? networking) then null  # NixOS system, no NixGL needed
    else if config.my.hyprland.nixgl.variant == "auto" then
      inputs.nixgl.packages.${pkgs.system}.nixGLIntel
    else if config.my.hyprland.nixgl.variant == "intel" then
      inputs.nixgl.packages.${pkgs.system}.nixGLIntel
    else if config.my.hyprland.nixgl.variant == "nvidia" then
      inputs.nixgl.packages.${pkgs.system}.nixGLNvidia
    else
      inputs.nixgl.packages.${pkgs.system}.nixGLMesa;

  # Conditional packages based on whether we're on NixOS or standalone
  additionalPackages = if (sys ? networking) then [] else [
    # NixGL package
    nixGLPackage
    
    # Hyprland essentials for standalone mode
    pkgs.hyprpolkitagent
    pkgs.waybar
    pkgs.wpaperd  
    pkgs.fuzzel
    pkgs.grim
    pkgs.slurp
    pkgs.hyprpicker
    pkgs.hyprlock
    pkgs.playerctl
    pkgs.wireplumber
    pkgs.brightnessctl
    pkgs.nautilus
    pkgs.networkmanagerapplet
    pkgs.foot
  ];
in {
  config = mkIf (sys.my.hyprland.enable or config.my.hyprland.enable) {
    home.packages = additionalPackages;

    wayland.windowManager.hyprland = {
      enable = true;
      package = pkgs.hyprland;
      xwayland.enable = true;
      extraConfig = ''
        ${sharedConfig scripts}

        # Browser binding (different for NixOS vs standalone)
        bind = $mainMod, W, exec, ${browserCmd}

        ${optionalString (sys ? networking && sys.networking.networkmanager.enable) 
          "exec-once = ${pkgs.networkmanagerapplet}/bin/nm-applet"}
      '';
    };

    # Enable XDG desktop portal for screen sharing (standalone mode only)
    xdg.portal = mkIf (!(sys ? networking)) {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
      ];
      config.common.default = "*";
    };
  };
}
