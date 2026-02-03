# =============================================================================
# VMWARE.NIX - Конфигурация ТОЛЬКО для тестирования в VMware
# =============================================================================
#
# ВНИМАНИЕ: Этот файл НЕ включается в основную сборку (nixos)!
# Используется только для конфигурации nixos-vmware.
#
# Для сборки под VMware:
#   sudo nixos-rebuild switch --flake .#nixos-vmware
#
# Для сборки под реальное железо:
#   sudo nixos-rebuild switch --flake .#nixos
#
# =============================================================================

{ config, pkgs, lib, ... }:

{
  # VMware Guest Tools - драйверы и интеграция с хостом
  virtualisation.vmware.guest.enable = true;

  # Автоматически запускаем vmware-user для буфера обмена и drag-drop
  # (включается автоматически при vmware.guest.enable)

  # Графика в VMware - используем виртуальный GPU
  # Отключаем некоторые эффекты для лучшей производительности
  services.xserver.videoDrivers = lib.mkForce [ "vmware" ];

  # Загрузчик для VMware (BIOS, не UEFI)
  # VMware по умолчанию использует BIOS, поэтому меняем на GRUB
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda";  # Виртуальный диск VMware
  };

  # Увеличиваем таймауты для виртуальной среды
  systemd.services.NetworkManager-wait-online.serviceConfig.TimeoutStartSec = "60s";

  # Дополнительные пакеты для VMware
  environment.systemPackages = with pkgs; [
    open-vm-tools  # CLI утилиты VMware
  ];

  # Для Hyprland в VMware может понадобиться software rendering
  # Раскомментируй если будут проблемы с графикой:
  # environment.variables.WLR_RENDERER_ALLOW_SOFTWARE = "1";

  # Размер экрана по умолчанию для VM
  # Автоматически подстраивается через vmware-user
}
