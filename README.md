# NixOS Anywhere + Disko Portable Template (x86/ARM / iPad UTM friendly)

This flake installs NixOS remotely using `nixos-anywhere` and partitions disks
with `disko`. It automatically detects the host CPU architecture and builds for
that unless overridden.

✅ Works from macOS ARM → x86  
✅ Works from x86 → ARM (iPad UTM, Raspberry Pi, ARM VPS)  
✅ 2 GiB EFI boot partition  
✅ `/dev/vda` default (UTM virtio)  

—

## Usage

### Clone

```bash
git clone https://github.com/YOURNAME/nixos-anywhere-utm-template my-host
cd my-host
```

### Edit your SSH key in flake.nix

nixos-anywhere —flake .#default root@IP


### Cross-building for ARM (example)

nixos-anywhere —flake .#default —system aarch64-linux root@IP

### Just build config locally” for sanity checking

nix build .#nixosConfigurations.default.config.system.build.toplevel


# Requirements

Target must boot a rescue Linux with:
	•	UEFI
	•	/dev/vda
	•	networking + ssh

For iPad UTM SE:
	•	UTM ARM VM
	•	UEFI boot
	•	virtio disk
	•	4–8 GB RAM recommended

Changing Disk Layout

See disko.nix. Examples:
	•	Btrfs snapshots
	•	LUKS encryption
	•	ZFS (ARM WIP)
