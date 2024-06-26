# This can be built with nixos-rebuild --flake .#myhost build
{
  description = "the simplest flake for nixos-rebuild";

  inputs = {
    nixpkgs = {
      # Using the nixos-unstable branch specifically, which is the
      # closest you can get to following the equivalent channel with flakes.
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";
    pipewire-screenaudio.url = "github:IceDBorn/pipewire-screenaudio";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs";
  };

  # Outputs can be anything, but the wiki + some commands define their own
  # specific keys. Wiki page: https://nixos.wiki/wiki/Flakes#Output_schema
  outputs = {
    self,
    nixpkgs,
    home-manager,
    alejandra,
    aagl,
    ...
  } @ inputs: {
    # nixosConfigurations is the key that nixos-rebuild looks for.
    nixosConfigurations = {
      vapor = nixpkgs.lib.nixosSystem rec {
        # A lot of times online you will see the use of flake-utils + a
        # function which iterates over many possible systems. My system
        # is x86_64-linux, so I'm only going to define that
        system = "x86_64-linux";
        # Import our old system configuration.nix
        modules = [
          ./hardware-configuration-vapor.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            environment.systemPackages = [alejandra.defaultPackage.${system}];
          }
          {
            _module.args = {inherit inputs;};
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # home-manager.users.uri = import ./home.nix

            # Optionally, use home-manager.extraSpecialArgs to pass
            # arguments to home.nix
          }
          {
            imports = [aagl.nixosModules.default];
            nix.settings = aagl.nixConfig; # Setup cachix
            programs.anime-game-launcher.enable = true;
          }
        ];
      };
    };
  };
}
