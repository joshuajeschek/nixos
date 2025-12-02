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

    elephant.url = "github:abenz1267/elephant";
    elephant.inputs.nixpkgs.follows = "nixpkgs";
    walker.url = "github:abenz1267/walker";
    walker.inputs.elephant.follows = "elephant";
    walker.inputs.nixpkgs.follows = "nixpkgs";

    nix-flatpak.url = "github:gmodena/nix-flatpak/";
  };

  outputs = inputs@{ nixpkgs, home-manager, sops-nix, ... }:
  let
    mkSystemModules = hostname: [
      ./system/${hostname}.nix
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
        home-manager.sharedModules = [
          inputs.sops-nix.homeManagerModules.sops
          inputs.walker.homeManagerModules.default
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
        ];
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
