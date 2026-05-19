# Boiler-plate/Reminder
> Another reminder snippet for possible future functions.
> Kconfig wrapper for "custom groups" where it actually just uses kconfiglib to read the Kconfig/makefiles
> Then outputs a .nix file like the below, which defines an equivalent (contains the same options) attribute set for
> each kconf group, and disabling a group can set the tristate for all config options in the group.

{ pkgs, lib, ... }:

let
  # 1. Define the structural groupings mapping to their exact leaf modules
  # (You can extract these lists once using 'kconfiglib' or the 'grep' method)
  kconfigGroups = {
    usb-drivers = [
      "USB_ANNOUNCE_NEW_DEVICES"
      "USB_XHCI_HCD"
      "USB_EHCI_HCD"
      "USB_OHCI_HCD"
      "USB_STORAGE"
    ];
    crypto-accel = [
      "CRYPTO_AES_NI_INTEL"
      "CRYPTO_CHACHA20_X86_64"
      "CRYPTO_SHA256_SSSE3"
    ];
    file-systems = [
      "BTRFS_FS"
      "XFS_FS"
      "EXT4_FS"
      "NTFS3_FS"
    ];
  };

  # 2. The core function wrapping Kconfig tristate assignments
  # It takes a group name and a tristate value, then returns a structured config attrset
  setGroupTristate = groupName: value:
    let
      # Lookup the leaf modules for the specified group
      modules = kconfigGroups.${groupName} or (throw "Kconfig group '${groupName}' not found!");
      
      # Convert the tristate value string to the specific format Nixpkgs expects
      nixValue = if value == "y" then lib.kernel.yes
                 else if value == "m" then lib.kernel.module
                 else lib.kernel.no;
                 
      # Map over each module name to create an attribute pair: { MODULE_NAME = nixValue; }
      attrList = map (mod: { name = mod; value = nixValue; }) modules;
    in
      # Collapse the list of pairs back into a single clean Nix attribute set
      builtins.listToAttrs attrList;

in {
  # 3. Apply it seamlessly to your kernel build via boot.kernelPatches
  boot.kernelPatches = [
    {
      name = "bulk-group-tristate-configuration";
      patch = null; # We are only injecting Kconfig options, no source patch code
      
      # Merge multiple group invocations together using standard attrset updating (//)
      structuredExtraConfig = 
        (setGroupTristate "usb-drivers" "y") //
        (setGroupTristate "file-systems" "m") //
        (setGroupTristate "crypto-accel" "n");
    }
  ];
}
