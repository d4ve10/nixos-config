#
#  Printer and Scanner Services
#
{ lib, pkgs, vars, ... }:

{
  services = {
    printing.enable = true;
    printing.drivers = with pkgs; [
      gutenprint
      gutenprintBin
      cups-filters
    ];
  };
  hardware = {
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
    };
  };
  users.users.${vars.user}.extraGroups = [ "scanner" "lp" ];
}
