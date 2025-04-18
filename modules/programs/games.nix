#
#  Gaming: Steam + MC + Emulation
#  Do not forget to enable Steam play for all title in the settings menu
#  When connecting a controller via bluetooth, it might error out. To fix this, remove device, pair - connect - trust, wait for auto disconnect, sudo rmmod btusb, sudo modprobe btusb, pair again.
#

{ config, pkgs, nur, lib, vars, ... }:

{
  config = lib.mkIf (config.gaming.enable) {
    users.groups.gamemode.members = [ "${vars.user}" ];
    users.groups.plugdev.members = [ "root" "${vars.user}" ];
    services.udev.extraRules = ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0664", GROUP="plugdev"
    ''; # Group and udev rule needed to have access to the controller's gyro

    hardware = {
      steam-hardware.enable = true; # Enable Steam Controller + Valve Index
      xone.enable = true; # Support for the Xbox controller USB dongle
    };

    environment.systemPackages = with pkgs; [
      # config.nur.repos.c0deaddict.oversteer # Steering Wheel Configuration
      # heroic # Game Launcher
      # lutris # Game Launcher
      prismlauncher # MC Launcher
      retroarch-free # Emulator
      protonup-qt # Proton-GE GUI Installer
      vulkan-tools # vkcube
      mesa-demos # glxgears

      # Cursor Fix for X11 apps
      xsettingsd
      xorg.xrdb
      # pcsx2 # Emulator
    ];

    programs = {
      steam = {
        enable = true;
        gamescopeSession.enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
        localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      };
      gamescope = {
        enable = true;
        capSysNice = false; # has to be disabled for now, see https://github.com/NixOS/nixpkgs/issues/351516
      };
      gamemode.enable = true;
      # Better Gaming Performance
      # Steam: Right-click game - Properties - Launch options: gamemoderun %command%
      # Lutris: General Preferences - Enable Feral GameMode
      #                             - Global options - Add Environment Variables: LD_PRELOAD=/nix/store/*-gamemode-*-lib/lib/libgamemodeauto.so
    };

    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-runtime"
    ];

    nixpkgs.config.packageOverrides = pkgs: {
      steam = pkgs.steam.override {
        extraPkgs = pkgs: with pkgs; [
          xorg.libXcursor
          xorg.libXi
          xorg.libXinerama
          xorg.libXScrnSaver
          libpng
          libpulseaudio
          libvorbis
          stdenv.cc.cc.lib
          libkrb5
          keyutils
        ];
      };
    };

    home-manager.users.${vars.user} = {
      programs = {
        mangohud = {
          enable = true;
          enableSessionWide = false; # session-wide enabled mangohud doesn't work well with gamescope
          settings = {
            gpu_stats = true;
            gpu_temp = true;
            cpu_stats = true;
            cpu_temp = true;
            fps = true;
            fps_color_change = true;
            frametime = true;
            arch = true;
            frame_timing = true;
            gamemode = true;
            no_display = true;
            toggle_hud = "Shift_R+F12";
            toggle_logging = "Shift_R+F11";
          };
        };
      };
    };
  };
}
