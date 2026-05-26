{
  config,
  pkgs,
  lib,
  sys,
  ...
}: let
  inherit (lib) mkIf;
  cfg = sys.my.gpu-screen-recorder;
in {
  config = mkIf cfg.enable {
    home.packages = [
      pkgs.gpu-screen-recorder-ui
      pkgs.unstable.gpu-screen-recorder
    ];

    systemd.user.services.gsr-ui = {
      Unit = {
        Description = "GPU Screen Recorder UI daemon";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${pkgs.gpu-screen-recorder-ui}/bin/gsr-ui launch-daemon";
        Restart = "on-failure";
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
