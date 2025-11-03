# NixOS Anywhere + Disko Portable Template

Remote NixOS installation with automatic disk partitioning using `nixos-anywhere` and `disko`. Supports multiple architectures via `nix-systems/default-linux`.

✅ Multi-architecture support (x86_64-linux, aarch64-linux, etc.)  
✅ Auto-detects build system or specify target explicitly  
✅ 2 GiB EFI boot partition  
✅ `/dev/vda` default (UTM virtio)  

## Usage

### Clone

```bash
git clone https://github.com/YOURNAME/nixos-anywhere-template my-host
cd my-host
```

### Edit your SSH key in flake.nix

```bash
nixos-anywhere --flake .#default root@IP
```

### Target specific architecture

```bash
nixos-anywhere --flake .#x86_64-linux root@IP
nixos-anywhere --flake .#aarch64-linux root@IP
```

### Build locally for validation

```bash
nix build .#nixosConfigurations.default.config.system.build.toplevel
```

## Requirements

Target must boot a rescue Linux with:
- UEFI
- `/dev/vda` (or customize in `disko.nix`)
- Networking + SSH access
- `cpio` and `libc` installed (for initrd building)

### For iPad UTM:
- UTM ARM VM with UEFI boot
- virtio disk
- 4-8 GB RAM recommended

## Customizing Disk Layout

Edit `disko.nix` to configure:
- Btrfs snapshots
- LUKS encryption
- Alternative filesystems
