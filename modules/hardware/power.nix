#
#  Power Management
#

{ config, lib, vars, ... }:

{
  config = lib.mkIf (config.laptop.enable) {
    services = {
      power-profiles-daemon.enable = true;
      tlp.enable = false;
      auto-cpufreq.enable = false;
    };
  };
}
