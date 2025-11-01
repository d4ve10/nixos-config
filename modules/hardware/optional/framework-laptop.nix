#
#  Framework Laptop specific hardware configuration
#

{ config, lib, pkgs, vars, inputs, ... }:

with lib;
{
  hardware = {
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };

    framework.laptop13.audioEnhancement = {
      enable = true;
      hideRawDevice = false;
    };
  };

  # Disabling keyboard backlight, because it resets it to zero every time (see https://github.com/DHowett/framework-laptop-kmod/pull/15)
  systemd.services."systemd-backlight@leds:framework_laptop::kbd_backlight".enable = lib.mkForce false;

  environment = {
    systemPackages = with pkgs; [
      framework-tool
      fw-ectool
    ];

    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };
  };

  hardware.fw-fanctrl.enable = true;
  hardware.fw-fanctrl.config.defaultStrategy = "lazy";
}
