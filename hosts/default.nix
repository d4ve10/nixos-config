#
#  These are the different profiles that can be used when building NixOS.
#
#  flake.nix
#   └─ ./hosts
#       ├─ default.nix *
#       ├─ configuration.nix
#       └─ ./<host>.nix
#           └─ default.nix
#

{ inputs, nixpkgs, nixpkgs-stable, nixos-hardware, nix-index-database, my_dotfiles, home-manager, nur, nixvim, plasma-manager, vars, fw-fanctrl, ... }:

let
  system = "x86_64-linux";

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };

  stable = import nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };

  lib = nixpkgs.lib;
in
{
  # Desktop Profile
  dave-pc = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system stable vars;
      host = {
        hostName = "dave-pc";
        # mainMonitor = "HDMI-A-2";
        # secondMonitor = "HDMI-A-1";
      };
    };
    modules = [
      nix-index-database.nixosModules.nix-index
      nur.nixosModules.nur
      nixvim.nixosModules.nixvim
      ./dave-pc
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
      }
    ];
  };

  # Personal Profile
  dave-framework = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs my_dotfiles system stable vars;
      host = {
        hostName = "dave-framework";
      };
    };
    modules = [
      nix-index-database.nixosModules.nix-index
      nixos-hardware.nixosModules.framework-11th-gen-intel
      fw-fanctrl.nixosModules.default
      nixvim.nixosModules.nixvim
      ./dave-framework
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
      }
    ];
  };

  # Gaming Profile
  dave-gaming = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs my_dotfiles system stable vars;
      host = {
        hostName = "dave-gaming-nixos";
      };
    };
    modules = [
      nix-index-database.nixosModules.nix-index
      nixvim.nixosModules.nixvim
      ./dave-gaming
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
      }
    ];
  };

  # VM Profile
  vm = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs system stable vars;
      host = {
        hostName = "vm";
        mainMonitor = "Virtual-1";
        secondMonitor = "";
        thirdMonitor = "";
      };
    };
    modules = [
      nix-index-database.nixosModules.nix-index
      nixvim.nixosModules.nixvim
      ./vm
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      }
    ];
  };
}
