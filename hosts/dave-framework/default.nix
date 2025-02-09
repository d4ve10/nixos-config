#
#  Personal system configuration settings
#

{ lib, pkgs, vars, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        mirroredBoots = [
          { 
            path = "/boot";
            efiBootloaderId = "Personal-NixOS";
            devices = [ "nodev" ];
          }
        ];
        devices = [ "nodev" ];
        efiSupport = true;
        efiInstallAsRemovable = false;
        useOSProber = true;
        configurationLimit = 10;
        default = 0;
      };
      timeout = 1;
    };
  };

  framework-laptop.enable = true;
  laptop.enable = true;
  kde.enable = true;
  virtualization.enable = true;

  services.tailscale.enable = true;
  systemd.services.tailscaled.wantedBy = lib.mkForce []; # Disable auto-start of tailscale

  systemd.services.NetworkManager-wait-online.enable = false;
}
