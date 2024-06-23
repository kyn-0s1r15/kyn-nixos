{
  description = "Nixos 0s1r15 flake";
  inputs = {
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-wayland";
    hyprland.url = "github:hyprwm/Hyprland";
    nix-colors.url = "github:misterio77/nix-colors";
  };
  outputs = { self, nixpkgs, home-manager, hyprland, nix-colors, ... }@inputs:

    let 
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};

    in {
      nixosConfigurations.nixos = lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
	  inherit system;
	  inherit lib;
	};
        modules = [
          ./0s1r15.nix
          ./configuration.nix
          home-manager.nixosModules.default
          hyprland.nixosModules.default
        ];
      };

      homeConfigurations.nixos = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
	  inherit system;
	  inherit lib;
        };

        modules = [
          ./0s1r15.nix
          {imports = [ <home-manager/nixos> ];}
          home-manager.nixosModules.default
          hyprland.homeManagerModules.default
        ];
      };
    };
}
  # ❯ pacli -c
  # Enter message:
  # > What egyption god best suits or most closely resembles the name Kynaston
  # ## AI Response:
  # The name Kynaston does not have a direct correlation with any specific Egyptian god. 
  # However, if we consider the meaning of the name Kynaston, which is of English origin 
  # and means "royal settlement" or "king's town", it could be loosely associated with 
  # Osiris. Osiris is one of the most important gods of ancient Egypt, often associated 
  # with the afterlife, resurrection, and kingship. But this is a very loose connection 
  # based on the meaning of the name only.
  # -------
