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
            efiBootloaderId = "Gaming-NixOS";
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
      input-leap
    ];
  };

  networking.firewall.enable = false;

  kde.enable = true;
  virtualization.enable = true;
  gaming.enable = true;

  services.displayManager.autoLogin.user = "${vars.user}";
  services.displayManager.autoLogin.enable = true;

  systemd.services.NetworkManager-wait-online.enable = false;
}
