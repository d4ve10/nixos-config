#
#  Main system configuration. More information available in configuration.nix(5) man page.
#
#  flake.nix
#   ├─ ./hosts
#   │   ├─ default.nix
#   │   └─ configuration.nix *
#   └─ ./modules
#       ├─ ./desktops
#       │   └─ default.nix
#       ├─ ./editors
#       │   └─ default.nix
#       ├─ ./hardware
#       │   └─ default.nix
#       ├─ ./programs
#       │   └─ default.nix
#       ├─ ./services
#       │   └─ default.nix
#       ├─ ./shell
#       │   └─ default.nix
#       ├─ ./theming
#       │   └─ default.nix
#       ├─ ./virtualization
#       │   └─ default.nix
#       └─ ./options.nix

{ lib, config, pkgs, stable, my_dotfiles, inputs, vars, host, ... }:

let
  terminal = pkgs.${vars.terminal};
in
{
  imports = (
    [ ../modules/options.nix ] ++
    import ../modules/desktops ++
    import ../modules/editors ++
    import ../modules/hardware ++
    import ../modules/programs ++
    import ../modules/services ++
    import ../modules/shell ++
    import ../modules/theming ++
    import ../modules/virtualization
  );

  boot = {
    tmp = {
      cleanOnBoot = true;
      tmpfsSize = "5GB";
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  users.users.${vars.user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "camera" "networkmanager" ];
  };

  networking = with host; {
    networkmanager.enable = true;
    wireguard.enable = true;
    # wireless.iwd.enable = true;
    # networkmanager.wifi.backend = "iwd";
    hostName = hostName;
    enableIPv6 = true;
    # Syncthing Ports
    firewall.allowedTCPPorts = [ 22000 ];
    firewall.allowedUDPPorts = [ 22000 21027 51820 ];
  };

  time.timeZone = "${vars.timeZone}";
  i18n = {
    defaultLocale = "${vars.defaultLocale}";
    extraLocaleSettings = {
      LC_ADDRESS = "${vars.LC_ADDRESS}";
      LC_IDENTIFICATION = "${vars.LC_IDENTIFICATION}";
      LC_MEASUREMENT = "${vars.LC_MEASUREMENT}";
      LC_MONETARY = "${vars.LC_MONETARY}";
      LC_NAME = "${vars.LC_NAME}";
      LC_NUMERIC = "${vars.LC_NUMERIC}";
      LC_PAPER = "${vars.LC_PAPER}";
      LC_TELEPHONE = "${vars.LC_TELEPHONE}";
      LC_TIME = "${vars.LC_TIME}";
    };
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  fonts = {
    packages = with pkgs; [
      carlito # NixOS
      vegur # NixOS
      source-code-pro
      jetbrains-mono
      font-awesome # Icons
      corefonts # MS
      noto-fonts # Google + Unicode
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.symbols-only
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["Meslo LG M Regular Nerd Font Complete Mono"];
        serif = ["Noto Serif" "Source Han Serif"];
        sansSerif = ["Noto Sans" "Source Han Sans"];
      };
    };
  };

  environment = {
    variables = {
      TERMINAL = "${vars.terminal}";
      EDITOR = "${vars.editor}";
      VISUAL = "${vars.editor}";
      BROWSER = "${vars.browser}";
    };
    systemPackages = with pkgs; [
      inputs.zen-browser.packages."${system}".default # Zen Browser Beta
      # Developing
      git # Version Control
      uv # Python Project Manager
      python3 # Python
      nodejs # Javascript
      nil # LSP for Nix
      mongosh # MongoDB Shell
      postman # API Testing

      # Sysadmin
      nmap # Network
      nettools # Network
      dig # DNS
      dnslookup # DNS
      inetutils # Network
      ansible # Automation
      sshpass # Ansible dependency
      postgresql # PostgreSQL Database
      mariadb # MariaDB Database

      # Terminal
      openssl # Security
      openvpn # VPN
      wireguard-tools # VPN
      openconnect # Cisco Anyconnect
      age # Encryption
      ethtool # Network Config
      syncthing # Sync Tool
      terminal # Terminal Emulator
      btop # Resource Manager
      htop # Resource Manager
      iftop # Network Monitor
      wavemon # Wifi Monitor
      nh # Nix Helper
      nvd # Nix Diff
      hdparm # Disk Management
      ncdu # Disk Usage
      cmatrix # Matrix
      cifs-utils # Samba
      coreutils # GNU Utilities
      killall # Process Killer
      lshw # Hardware Config
      nano # Text Editor
      nodejs # Javascript Runtime
      nodePackages.pnpm # Package Manager
      nix-tree # Browse Nix Store
      nix-du # Nix Disk Usage
      pciutils # Manage PCI
      ranger # File Manager
      smartmontools # Disk Health
      tldr # Helper
      usbutils # Manage USB
      wget # Retriever
      xdg-utils # Environment integration
      jdk23 # Java
      screenfetch # System Info
      powertop # Power Management
      screen # Terminal Multiplexer
      traceroute # Network
      tree # Directory
      wireshark-qt # Network

      # Video/Audio
      alsa-utils # Audio Control
      linux-firmware # Proprietary Hardware Blob
      mpv # Media Player
      pavucontrol # Audio Control
      pipewire # Audio Server/Control
      pulseaudio # Audio Server/Control
      qpwgraph # Pipewire Graph Manager
      vlc # Media Player
      handbrake # Video Converter
      imagemagick # Image Converter

      # Apps
      appimage-run # Runs AppImages on NixOS
      firefox # Browser
      google-chrome # Browser
      brave # Browser
      remmina # XRDP & VNC Client
      obsidian # Notes
      obs-studio # Recording
      simple-scan # Scanning
      discord # Chat
      flameshot # Screenshot Tool
      gimp # Image Editor
      inkscape # Vector Editor
      networkmanager-vpnc # VPN
      networkmanager-openvpn # VPN
      networkmanager-openconnect # VPN
      trayscale # Tray Icon
      signal-desktop # Chat
      solaar # Logitech Unifying Receiver
      thunderbird # Email
      birdtray # Thunderbird Tray Icon
      vscode # Code Editor
      element-desktop # Chat
      krdc # Remote Desktop
      rustdesk-flutter # Remote Desktop
      localsend # Local File Sharing
      logseq # Notes
      joplin-desktop # Notes
      graphviz # Graphs
      zgrviewer # Graphs Viewer
      drawio # Diagrams

      # File Management
      p7zip # Zip Encryption
      rsync # Syncer - $ rsync -r dir1/ dir2/
      unzip # Zip Files
      unrar # Rar Files
      zip # Zip
      rclone # Gdrive ($ rclone config | rclone mount --daemon gdrive: <mount> | fusermount -u <mount>)

      # Misc
      cacert # CA Certificates
      efibootmgr # EFI Boot Manager
      libreoffice # Office
      qFlipper # Flipper Zero
      ferdium # Services Manager

      # Security
      yubioath-flutter # Yubikey Authenticator
      yubikey-manager # Yubikey CLI
      bitwarden-desktop # Bitwarden Desktop

      # University
      vmware-horizon-client # Remote Desktop

      # Other Packages Found @
      # - ./<host>/default.nix
      # - ../modules
    ] ++
    (with stable; [
      # Apps
      # firefox # Browser
    ]);

    etc."current-system-packages".text =
      let
        packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
        sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
        formatted = builtins.concatStringsSep "\n" sortedUnique;
      in
        formatted;
  };

  nixpkgs.config.permittedInsecurePackages = [
    "electron-27.3.11" # Logseq
  ];

  programs.firefox = {
    enable = true;
    nativeMessagingHosts.packages = [ pkgs.kdePackages.plasma-browser-integration ];
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      "widget.use-xdg-desktop-portal.settings" = 1;
    };
  };

  services.syncthing = {
    enable = true;
    user = vars.user;
    dataDir = "/home/${vars.user}";
  };
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder


  programs = {
    dconf.enable = true;
    nix-ld = {
      enable = true;
      libraries = [];
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
      settings = {
        defaultCacheTTL = 28800;
        maxCacheTTL = 28800;
      };
    };
    ssh = {
      startAgent = true;
      enableAskPassword = true;
      extraConfig = ''
        AddKeysToAgent yes
      '';
    };
  };

  services = {
    openssh = {
      enable = true;
      allowSFTP = true;
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      '';
    };
    pcscd.enable = true;
    udev.packages = [ pkgs.yubikey-personalization ];
  };

  flatpak.enable = true;

  nix = {
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    # package = pkgs.nixVersions.latest;
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true;

  system = {
    # autoUpgrade = {
    #   enable = true;
    #   channel = "https://nixos.org/channels/nixos-unstable";
    # };
    stateVersion = "24.11";
  };

  home-manager.users.${vars.user} = {
    home = {
      stateVersion = "24.11";
    };
    programs = {
      home-manager.enable = true;
    };
    home.file.".mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json".source = "${pkgs.kdePackages.plasma-browser-integration}/lib/mozilla/native-messaging-hosts/org.kde.plasma.browser_integration.json";
    # xdg.configFile."mimeapps.list".force = true;
    # xdg = {
    #   mime.enable = true;
    #   mimeApps = {
    #     enable = true;
    #     defaultApplications = {
    #       "audio/mp3" = "mpv.desktop";
    #       "audio/x-matroska" = "mpv.desktop";
    #       "video/webm" = "mpv.desktop";
    #       "video/mp4" = "mpv.desktop";
    #       "video/x-matroska" = "mpv.desktop";
    #     };
    #   };
    # };
  };
}
