#
#  Printer and Scanner Services
#
{ lib, pkgs, vars, ... }:

{
  services = {
    printing = {
      enable = true;
      browsed.enable = true;
      drivers = with pkgs; [
        gutenprint
        gutenprintBin
        canon-cups-ufr2
        cnijfilter2
        cups-bjnp
        cups-browsed
        cups-filters
      ];
    };
  };
  hardware = {
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      openFirewall = true;
    };
  };
  users.users.${vars.user}.extraGroups = [ "scanner" "lp" ];
}
