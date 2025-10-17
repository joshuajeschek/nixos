{
  description = "NixOS system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:youwen5/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    private.url = "path:./private";
    private.flake = false;
  };

  outputs = inputs@{ nixpkgs, home-manager, sops-nix, ... }:
  let
    mkSystemModules = hostname: [
      ./configuration.nix
      sops-nix.nixosModules.sops
      {
        networking.hostName = hostname;
      }
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.main = import ./home/${hostname}.nix;
        home-manager.extraSpecialArgs = { inherit inputs hostname; };
        home-manager.sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
      }
    ];
  in
  {
    nixosConfigurations = {
      terra = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = mkSystemModules "terra";
      };
      spectre = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = mkSystemModules "spectre";
      };
    };
  };
}
