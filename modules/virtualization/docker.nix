#
#  Docker
#

{ config, lib, pkgs, vars, ... }:

with lib;
{
  config = mkIf (config.virtualization.enable) {
    virtualisation = {
      docker.enable = true;
    };

    users.groups.docker.members = [ "${vars.user}" ];

    environment.systemPackages = with pkgs; [
      docker # Containers
      docker-compose # Multi-Container
    ];
  };
}
