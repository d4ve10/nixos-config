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
    import ../modules/networking ++
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
    extraGroups = [ "wheel" "video" "audio" "camera" ];
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
    systemPackages = with pkgs; with pkgs.kdePackages; with inputs; [

      # Development Tools
      distrobox # Create small VMs
      git # Version Control
      go # Go
      godot # Game Engine
      jdk23 # Java
      mariadb # MariaDB Database
      mongosh # MongoDB Shell
      nil # LSP for Nix
      nixfmt-rfc-style # Nix formatting
      nodejs # Javascript
      nodePackages.pnpm # Package Manager
      postgresql # PostgreSQL Database
      postman # API Testing
      python3 # Python
      rustup # Rust
      uv # Python Project Manager

      # Networking
      dig # DNS
      dnslookup # DNS
      inetutils # Network
      nettools # Network
      nmap # Network
      openconnect # Cisco Anyconnect
      openvpn # VPN
      rustscan # Network
      sshfs # Mount
      traceroute # Network
      wavemon # Wifi Monitor
      wireguard-tools # VPN
      wireshark-qt # Network Analyzer

      # System Utilities
      adwaita-icon-theme # Icons for GTK apps
      age # Encryption Tool
      ansible # Automation
      appimage-run # Runs AppImages on NixOS
      btop # Resource Manager
      cifs-utils # Samba
      cacert # CA Certificates
      cmatrix # Matrix
      coreutils # GNU Utilities
      ddcutil # Monitor Control
      ddcui # Monitor Control GUI
      efibootmgr # EFI Boot Manager
      ethtool # Network Config
      hdparm # Disk Management
      htop # Resource Manager
      i2c-tools # I2C
      iftop # Network Monitor
      iperf # Network Speed
      killall # Process Killer
      konsole # Terminal Emulator
      linux-firmware # Proprietary Hardware Blob
      lshw # Hardware Config
      nano # Text Editor
      ncdu # Disk Usage
      nh # Nix Helper
      nix-du # Nix Disk Usage
      nix-tree # Browse Nix Store
      nvd # Nix Diff
      openssl # Security
      pciutils # Manage PCI
      powertop # Power Management
      ripgrep # Search
      screen # Terminal Multiplexer
      screenfetch # System Info
      smartmontools # Disk Health
      sshpass # Ansible dependency
      tldr # Helper
      tree # Directory
      usbutils # Manage USB
      wget # Retriever
      xdg-utils # Environment integration

      # Media & Graphics
      alsa-utils # Audio Control
      handbrake # Video Converter
      imagemagick # Image Converter
      mpv # Media Player
      pavucontrol # Audio Control
      pipewire # Audio Server/Control
      pulseaudio # Audio Server/Control
      qpwgraph # Pipewire Graph Manager
      vlc # Media Player

      # Security & Privacy
      bitwarden-desktop # Bitwarden Desktop
      keepassxc # Password Manager
      yubikey-manager # Yubikey CLI
      yubioath-flutter # Yubikey Authenticator

      # Office & Productivity
      joplin-desktop # Notes
      libreoffice-qt6 # Office
      obsidian # Notes

      # File Management
      p7zip # Zip Encryption
      ranger # File Manager
      rclone # Rsync for Cloud Storage
      rsync # File Sync
      syncthing # Sync Tool
      unrar # Rar Files
      unzip # Zip Files
      zip # Zip

      # Virtualization & Remote Access
      krdc # Remote Desktop
      remmina # XRDP & VNC Client
      vmware-horizon-client # Remote Desktop

      # Applications
      birdtray # Thunderbird Tray Icon
      brave # Browser
      discord # Chat
      drawio # Diagrams
      element-desktop # Chat
      ferdium # Services Manager
      flameshot # Screenshot Tool
      gimp # Image Editor
      google-chrome # Browser
      graphviz # Graphs
      inkscape # Vector Editor
      localsend # Local File Sharing
      obs-studio # Recording
      qFlipper # Flipper Zero
      signal-desktop # Chat
      simple-scan # Scanning
      solaar # Logitech Unifying Receiver
      thunderbird # Email
      trayscale # Tray Icon
      vscode # Code Editor
      zen-browser.packages."${system}".default # Zen Browser Beta
      zgrviewer # Graphs Viewer

      # Miscellaneous

      # Other Packages Found @
      # - ./<host>/default.nix
      # - ../modules
    ] ++
    (with stable; [
      # Virtualization & Remote Access
      rustdesk-flutter # Remote Desktop
    ]);

    etc."current-system-packages".text =
      let
        packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
        sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
        formatted = builtins.concatStringsSep "\n" sortedUnique;
      in
        formatted;

    etc.hosts.mode = "0644";
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Enable Logitech Unifying Receiver
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

  # Enable I2C for ddcutil
  hardware.i2c.enable = true;

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
    nix-index-database.comma.enable = true;
    dconf.enable = true;
    nix-ld = {
      enable = true;
      libraries = [];
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
      settings = {
        default-cache-ttl = 28800;
        max-cache-ttl = 28800;
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

  home-manager.backupFileExtension = "backup";
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
