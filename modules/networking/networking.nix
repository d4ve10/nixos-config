{ pkgs, vars, inputs, host, ... }:


{
  networking = {
    networkmanager.enable = true;
    networkmanager.wifi.powersave = true;
    wireguard.enable = true;
    # wireless.iwd.enable = true;
    # networkmanager.wifi.backend = "iwd";
    hostName = host.hostName;
    enableIPv6 = true;
    usePredictableInterfaceNames = false;

    firewall = {
      allowedTCPPorts = [
        22000 # Syncthing
      ];
      allowedUDPPorts = [
        22000 # Syncthing
        21027 # Syncthing Discovery
        51820 # Wireguard
      ];
    };
  };

  users.users.${vars.user}.extraGroups = [ "networkmanager" ];
}
