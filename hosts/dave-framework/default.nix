#
#  Personal system configuration settings
#

{ lib, pkgs, vars, ... }:

{
  imports = [ ./hardware-configuration.nix ./../../modules/hardware/optional/framework-laptop.nix ];

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

  environment = {
    systemPackages = with pkgs; [
      headsetcontrol
    ];
  };
  services.udev.packages = [ pkgs.headsetcontrol ];

  laptop.enable = true;
  kde.enable = true;
  virtualization.enable = true;
  gaming.enable = true;

  services.tailscale.enable = true;
  systemd.services.tailscaled.wantedBy = lib.mkForce []; # Disable auto-start of tailscale

  systemd.services.NetworkManager-wait-online.enable = false;
}
