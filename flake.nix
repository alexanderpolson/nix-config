{
  description = "NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    claude-code = {
      url = "github:sadjow/claude-code-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, hyprland, claude-code, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # ── Change these to match your setup ──────────────────────────────
      hostname = "nixos";
      username = "apolson";
      # ──────────────────────────────────────────────────────────────────
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit hyprland; };
        modules = [
          ./hosts/${hostname}/configuration.nix
          hyprland.nixosModules.default

          # Allow unfree packages (required for warp-terminal)
          { nixpkgs.config.allowUnfree = true; }

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit hyprland; };
            home-manager.sharedModules = [{
              nixpkgs.overlays = [ claude-code.overlays.default ];
            }];
            home-manager.users.${username} = import ./home/default.nix;
          }
        ];
      };
    };
}
