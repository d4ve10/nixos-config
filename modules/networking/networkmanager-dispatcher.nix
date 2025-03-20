{ pkgs, ... }:

{
  networking.networkmanager.dispatcherScripts = [
    {
      type = "basic";
      source = pkgs.writeShellScript "wifi-auto-toggle" ''
        LOG_PREFIX="WiFi Auto-Toggle"
        ETHERNET_INTERFACE="eth0"

        if [ "$1" = "$ETHERNET_INTERFACE" ]; then
            case "$2" in
                up)
                    echo "$LOG_PREFIX ethernet up"
                    ${pkgs.networkmanager}/bin/nmcli radio wifi off
                    ;;
                down)
                    echo "$LOG_PREFIX ethernet down"
                    ${pkgs.networkmanager}/bin/nmcli radio wifi on
                    ;;
            esac
        elif [ "$(${pkgs.networkmanager}/bin/nmcli -g GENERAL.STATE device show $ETHERNET_INTERFACE)" = "20 (unavailable)" ]; then
            echo "$LOG_PREFIX failsafe"
            ${pkgs.networkmanager}/bin/nmcli radio wifi on
        fi
      '';
    }
  ];
}