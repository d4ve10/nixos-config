#
#  Framework Laptop specific hardware configuration
#  Enable with "framework-laptop.enable = true;"
#

{ config, lib, pkgs, vars, inputs, ... }:

with lib;
{
  config = mkIf (config.framework-laptop.enable) {
    hardware = {
      graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-vaapi-driver
          vaapiIntel
          vaapiVdpau
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

  };
}
