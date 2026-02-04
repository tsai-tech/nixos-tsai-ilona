# =============================================================================
# VMWARE.NIX — стабильный профиль для VMware + nested Hyprland
# =============================================================================

{ config, pkgs, lib, ... }:

{
  # VMware Guest Tools
  virtualisation.vmware.guest.enable = true;

  # Загрузчик (BIOS)
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";
  };

  # ---------------------------------------------------------------------------
  # X11 — ОБЯЗАТЕЛЕН (Hyprland будет запускаться nested)
  # ---------------------------------------------------------------------------
  services.xserver = {
    enable = true;
    videoDrivers = [ "vmware" ];

    windowManager.i3.enable = true;
    displayManager.startx.enable = true;
  };

  # ---------------------------------------------------------------------------
  # Hyprland (nested mode)
  # ---------------------------------------------------------------------------
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # ---------------------------------------------------------------------------
  # Графика (новая модель NixOS)
  # ---------------------------------------------------------------------------
  hardware.graphics.enable = true;

  # vmwgfx
  boot.kernelModules = [ "vmwgfx" ];

  # ---------------------------------------------------------------------------
  # Переменные окружения — КЛЮЧЕВЫЕ
  # ---------------------------------------------------------------------------
  environment.variables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBGL_ALWAYS_SOFTWARE = "1";
  };

  # ---------------------------------------------------------------------------
  # Увеличиваем таймауты для VM
  # ---------------------------------------------------------------------------
  systemd.services.NetworkManager-wait-online.serviceConfig.TimeoutStartSec = "60s";
}
