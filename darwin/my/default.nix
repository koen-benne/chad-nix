{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.my = {
    home = mkOption {type = types.str;};
  };
  config = {
    my = {
      home = "/Users/${config.my.user}";
    };
  };
}
