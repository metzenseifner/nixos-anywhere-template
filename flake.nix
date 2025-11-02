{
  description = "Portable NixOS anywhere + disko template (ARM/x86 auto)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, disko, ... }@inputs:
    let
      # host architecture we are running the flake on
      hostSystem = builtins.currentSystem;

      # helper: default to host if user doesn't pass --system
      mkSystem = targetSystem:
        nixpkgs.lib.nixosSystem {
          system = if targetSystem != null then targetSystem else hostSystem;
          modules = [
            disko.nixosModules.disko
            ./disko.nix
            {
              # base system settings
              networking.hostName = "utm-auto";

              boot.loader.systemd-boot.enable = true;
              boot.loader.efi.canTouchEfiVariables = true;

              services.openssh.enable = true;

              users.users.root.openssh.authorizedKeys.keys = [
                # 👉 replace with your key
                "ssh-ed25519 AAAABBBB...yourkey"
              ];

              time.timeZone = "UTC";
              networking.useDHCP = true;

              # bump when upgrading major nixos release
              system.stateVersion = "24.05";
            }
          ];
        };
    in {
      # one config entry -- arch auto-detect unless overridden via --system
      nixosConfigurations.default = mkSystem null;
    };
}