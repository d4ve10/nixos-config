#
#  Options to enable certain modules.
#

{ lib, ... }:

with lib;
{
  options = {
    kde = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
    laptop = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
    suspend-then-hibernate = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
    virtualization = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
    gaming = {
      enable = mkOption {
        type = types.bool;
        default = false;
      };
    };
  };
}
