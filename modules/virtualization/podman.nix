#
#  Podman
#

{ config, lib, pkgs, ... }:

with lib;
{
  config = mkIf (config.virtualization.enable) {
    virtualisation = {
      podman.enable = true;
    };

    environment.systemPackages = with pkgs; [
      podman-compose # Multi-Container
    ];
  };
}
