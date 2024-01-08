# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelModules = ["kvm-amd" "v4l2loopback"];
  boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
  boot.extraModprobeConfig = ''
    options snd_usb_audio vid=0x1235 pid=0x8211 device_setup=1
  '';
  #hardware.cpu.amd.updateMicrocode = true;

  systemd.tmpfiles.rules = [
    # "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    "L+    /opt/amdgpu   -    -    -     -    ${pkgs.libdrm}"
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f66eca28-c5e9-4a9d-ba5d-17d9cb43d42a";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/985D-9B8A";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/004a816f-9715-4515-9dac-ca261aa2e7d9";
    fsType = "ext4";
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp6s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp5s0.useDHCP = lib.mkDefault true;

  # nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  ### AMD STUFF
  hardware.opengl = {
    # Mesa
    enable = true;
    extraPackages = with pkgs; [mangohud amdvlk rocm-opencl-icd];
    extraPackages32 = with pkgs; [mangohud driversi686Linux.amdvlk];

    # Vulkan
    driSupport = true;
    driSupport32Bit = true;
  };

  # Force radv
  environment.variables.AMD_VULKAN_ICD = "RADV";
  networking.hostName = "uridesk"; # Define your hostname.
}