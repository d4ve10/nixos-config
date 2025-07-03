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
        extraConfig = "play 1750 523 1 392 1 523 1 659 1 784 1 1047 1 784 1 415 1 523 1 622 1 831 1 622 1 831 1 1046 1 1244 1 1661 1 1244 1 466 1 587 1 698 1 932 1 1195 1 1397 1 1865 1 1397 1";
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
