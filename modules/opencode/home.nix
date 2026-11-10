{inputs, ...}: {
  imports = [inputs.opencode-config.homeManagerModules.default];

  programs.opencodeConfig.enable = true;
}
