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

{ inputs, nixpkgs, nixos-hardware, disko, nix-index-database, my_dotfiles, home-manager, nixvim, plasma-manager, vars, ... }:

let
  system = "x86_64-linux";

  lib = nixpkgs.lib;
in
{
  # Personal Profile
  dave-framework = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs my_dotfiles system vars;
      host = {
        hostName = "dave-framework";
      };
    };
    modules = [
      nix-index-database.nixosModules.nix-index
      nixos-hardware.nixosModules.framework-intel-core-ultra-series3
      nixvim.nixosModules.nixvim
      ./dave-framework
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];
      }
    ];
  };

  # Gaming Profile
  dave-gaming = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs my_dotfiles system vars;
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
        home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];
      }
    ];
  };

  # Acer Predator Profile
  dave-predator = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs my_dotfiles system vars;
      host = {
        hostName = "dave-predator";
      };
    };
    modules = [
      nix-index-database.nixosModules.nix-index
      nixvim.nixosModules.nixvim
      disko.nixosModules.disko
      ./dave-predator
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];
      }
    ];
  };

  # VM Profile
  vm = lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit inputs my_dotfiles system vars;
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
