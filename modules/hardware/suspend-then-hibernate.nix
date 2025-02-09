#
#  Hibernation
#

{ config, lib, vars, ... }:

{
  config = lib.mkIf (config.suspend-then-hibernate.enable) {
    systemd.sleep.extraConfig = ''
      HibernateDelaySec=120min
    '';
    systemd.services."systemd-suspend-then-hibernate".aliases = [ "systemd-suspend.service" ];
  };
}
