{
  lib,
  pkgs,
  config,
  namespace,
  ...
}:

with lib;

let
  cfg = config.${namespace}.drivers.nvidia; # Config path
in
{
  # --- Set options
  options.${namespace}.drivers.nvidia = {
    enable = mkEnableOption "Enables nvidia drivers for host";
    withCuda = mkEnableOption "Enables CUDA for nvidia gpus";

    prime.enable = mkEnableOption "Enables Nvidia Prime (Must specify a the intel and nvidia PCIs)";
    prime.useSync = mkEnableOption "Use sync mode instead of offload mode for Nvidia Prime";
    prime.nvidiaBusId = mkOption {
      type = types.str;
      description = "The bus id for the Nvidia gpu";
    };
    prime.intelBusId = mkOption {
      type = types.str;
      description = "The bus id for the Intel gpu";
    };
  };

  # --- Set configuration
  config = mkIf cfg.enable {
    # Enable OpenGL
    hardware.graphics = {
      enable = true;
    };

    # Disable nouveau
    boot.kernelParams = [ "module_blacklist=nouveau" ];

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    # Enable cuda if needed
    environment.systemPackages =
      with pkgs;
      mkIf cfg.withCuda [
        cudaPackages.cudatoolkit
        egl-wayland
      ];

    # Configure nvidia prime if specified
    hardware.nvidia.prime = mkIf cfg.prime.enable {
      # Enable offload mode by default, sync if specified
      offload = mkIf (!cfg.prime.useSync) {
        enable = true;
        enableOffloadCmd = true;
      };

      sync.enable = mkIf cfg.prime.useSync true;

      # Make sure to use the correct Bus ID values for your system!
      nvidiaBusId = cfg.prime.nvidiaBusId;
      intelBusId = cfg.prime.intelBusId;
    };
  };
}
