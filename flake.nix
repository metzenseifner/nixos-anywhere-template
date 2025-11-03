{
  description = "Portable NixOS anywhere + disko template (ARM/x86)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    systems.url = "github:nix-systems/default-linux";
  };

  outputs = { self, nixpkgs, disko, systems, ... }@inputs:
    let
      forEachSystem =
        f: nixpkgs.lib.genAttrs (import systems) (system: f { inherit system; pkgs = import nixpkgs { inherit system; }; });

      mkConfiguration = system: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          disko.nixosModules.disko
          ./disko.nix
          {
            networking.hostName = "utm-auto";

            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;

            services.openssh.enable = true;

            users.users.root.openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAABBBB...yourkey"
            ];

            time.timeZone = "UTC";
            networking.useDHCP = true;

            system.stateVersion = "24.05";
          }
        ];
      };
    in {
      nixosConfigurations = forEachSystem ({ system, ... }: mkConfiguration system) // {
        default = self.nixosConfigurations.${builtins.currentSystem} or self.nixosConfigurations."x86_64-linux";
      };

      templates = {
        default = {
          path = ./.;
          description = "Portable NixOS anywhere + disko template (ARM/x86)";
          welcomeText = ''
            # NixOS Anywhere + Disko Template
            
            This template provides portable NixOS configurations for multiple
            architectures using nix-systems/default-linux.
            
            Next steps:
            1. Edit flake.nix to add your SSH public key
            2. Customize disko.nix for your disk layout
            3. Deploy: nixos-anywhere --flake .#default root@your-host
               Or target specific arch: .#x86_64-linux or .#aarch64-linux
          '';
        };
      };
    };
}