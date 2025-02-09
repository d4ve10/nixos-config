{
  inputs =
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; # Nix Packages (Default)
      nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11"; # Stable Nix Packages
      nixos-hardware.url = "github:nixos/nixos-hardware/master"; # Hardware Specific Configurations

      my_dotfiles = {
        url = "github:d4ve10/dotfiles";
        flake = false;
      };

      # User Environment Manager
      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      # Stable User Environment Manager
      home-manager-stable = {
        url = "github:nix-community/home-manager/release-24.11";
        inputs.nixpkgs.follows = "nixpkgs-stable";
      };

      # NUR Community Packages
      nur = {
        url = "github:nix-community/NUR";
        # Requires "nur.nixosModules.nur" to be added to the host modules
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

      # Neovim
      nixvim-stable = {
        url = "github:nix-community/nixvim/nixos-24.11";
        inputs.nixpkgs.follows = "nixpkgs-stable";
      };

      # KDE Plasma User Settings Generator
      plasma-manager = {
        url = "github:pjones/plasma-manager";
        inputs.nixpkgs.follows = "nixpkgs";
        inputs.home-manager.follows = "nixpkgs";
      };

      zen-browser.url = "github:0xc000022070/zen-browser-flake";
    };

  outputs = inputs @ { self, nixpkgs, nixpkgs-stable, nixos-hardware, my_dotfiles, home-manager, home-manager-stable, nur, nixgl, nixvim, nixvim-stable, plasma-manager, zen-browser, ... }: # Function telling flake which inputs to use
    let
      # Variables Used In Flake
      vars = {
        user = "dave10";
        terminal = "konsole";
        editor = "nvim";
        browser = "firefox";
        timeZone = "Europe/Berlin";

        defaultLocale = "en_US.UTF-8";
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
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-stable nixos-hardware my_dotfiles home-manager nur nixvim plasma-manager zen-browser vars; # Inherit inputs
        }
      );

      homeConfigurations = (
        import ./nix {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-stable home-manager nixgl vars;
        }
      );
    };
}
