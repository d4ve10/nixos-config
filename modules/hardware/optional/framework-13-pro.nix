#
#  Framework Laptop 13 Pro specific hardware configuration
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

  };

  environment = {
    systemPackages = with pkgs; [
      framework-tool
      fw-ectool
    ];

    sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };
  };
}
