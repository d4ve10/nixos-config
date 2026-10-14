{
  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # Nix Packages (Default)
      nixos-hardware.url = "github:nixos/nixos-hardware/master"; # Hardware Specific Configurations
      nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

      nix-index-database = {
        url = "github:nix-community/nix-index-database";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      my_dotfiles = {
        url = "github:d4ve10/dotfiles";
        flake = false;
      };

      # User Environment Manager
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # Disko - NixOS Installer
      disko = {
        url = "github:nix-community/disko";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # Fixes OpenGL With Other Distros.
      nixgl = {
        url = "github:guibou/nixGL";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # Neovim
      nixvim = {
        url = "github:nix-community/nixvim";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # KDE Plasma User Settings Generator
      plasma-manager = {
        url = "github:pjones/plasma-manager";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "nixpkgs";
      };

      zen-browser.url = "github:0xc000022070/zen-browser-flake";
    };

  outputs = inputs @ { self, nixpkgs, nixos-hardware, nix-cachyos-kernel, nix-index-database, my_dotfiles, home-manager, disko, nixgl, nixvim, plasma-manager, zen-browser, ... }: # Function telling flake which inputs to use
    let
      # Variables Used In Flake
      vars = {
        user = "dave10";
        terminal = "konsole";
        editor = "nvim";
        browser = "firefox";
        timeZone = "Europe/Berlin";
        wirelessRegulatoryDomain = "DE";

        defaultLocale = "en_US.UTF-8";
        locales = {
          LC_ADDRESS = "de_DE.UTF-8";
          LC_IDENTIFICATION = "de_DE.UTF-8";
          LC_MEASUREMENT = "de_DE.UTF-8";
          LC_MONETARY = "de_DE.UTF-8";
          LC_NAME = "de_DE.UTF-8";
          LC_NUMERIC = "en_US.UTF-8";
          LC_PAPER = "de_DE.UTF-8";
          LC_TELEPHONE = "de_DE.UTF-8";
          LC_TIME = "de_DE.UTF-8";
        };
      };
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs disko nixos-hardware nix-cachyos-kernel nix-index-database my_dotfiles home-manager nixvim plasma-manager zen-browser vars; # Inherit inputs
        }
      );

      homeConfigurations = (
        import ./nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs home-manager nixgl vars;
        }
      );
    };
}
