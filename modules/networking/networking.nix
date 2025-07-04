{ pkgs, vars, inputs, host, ... }:


{
  networking = {
    networkmanager.enable = true;
    networkmanager.wifi.powersave = true;
    networkmanager.plugins = with pkgs; [
      networkmanager-openvpn
    ];
    wireguard.enable = true;
    # wireless.iwd.enable = true;
    # networkmanager.wifi.backend = "iwd";
    hostName = host.hostName;
    enableIPv6 = true;
    usePredictableInterfaceNames = false;

    firewall = {
      checkReversePath = "loose"; # loose instead of strict for wireguard connections
      allowedTCPPorts = [
        22000 # Syncthing
        53317 # LocalSend
      ];
      allowedUDPPorts = [
        22000 # Syncthing
        21027 # Syncthing Discovery
        51820 # Wireguard
        53317 # LocalSend
      ];
    };
  };

  users.users.${vars.user}.extraGroups = [ "networkmanager" ];
}
