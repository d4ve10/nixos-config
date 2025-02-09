#
#  Printer and Scanner Services
#
{ lib, pkgs, vars, ... }:

{
  services = {
    printing.enable = true;
  };
  hardware = {
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };
  users.users.${vars.user}.extraGroups = [ "scanner" "lp" ];
}
