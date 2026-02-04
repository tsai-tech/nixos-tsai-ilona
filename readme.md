# NixOS Configuration - Mikhail Tsai

Декларативная конфигурация NixOS с Hyprland (Wayland) и Home Manager.

## Структура проекта

```
├── flake.nix                   # Точка входа, определяет две конфигурации
├── configuration.nix           # Основная системная конфигурация
├── home.nix                    # Home Manager (импортирует модули)
├── vmware.nix                  # VMware-специфичные настройки (только для тестирования)
├── hardware-configuration.nix  # Генерируется на целевой системе (не в git)
└── home/
    ├── hyprland.nix            # Hyprland + hypridle + hyprlock + hyprpaper
    └── waybar.nix              # Waybar конфиг + стили
```

## Конфигурации

| Конфигурация | Команда | Использование |
|--------------|---------|---------------|
| `nixos` | `--flake .#nixos` | Реальное железо (ноутбук) |
| `nixos-vmware` | `--flake .#nixos-vmware` | Тестирование в VMware |

## Установка

### 1. Установка NixOS

Скачай [NixOS Graphical ISO](https://nixos.org/download/) и установи через графический установщик.

### 2. Клонирование конфигурации

После установки и перезагрузки:

```bash
# Сохрани hardware-configuration.nix (создан установщиком)
cp /etc/nixos/hardware-configuration.nix ~/hardware-configuration.nix.bak

# Удали стандартную конфигурацию и клонируй репозиторий
sudo rm -rf /etc/nixos
sudo git clone https://github.com/mikhailtsai/nixos-tsai.git /etc/nixos
sudo chown -R $USER:users /etc/nixos

# Скопируй hardware-configuration.nix в репозиторий
cp ~/hardware-configuration.nix.bak /etc/nixos/hardware-configuration.nix
```

### 3. Применение конфигурации

```bash
cd /etc/nixos

# add hardware-configuration.nix to repository
sudo git add hardware-configuration.nix

# Для реального железа
sudo nixos-rebuild switch --flake .#nixos

# Для VMware
sudo nixos-rebuild switch --flake .#nixos-vmware
```

### 4. Перезагрузка

```bash
sudo reboot
```

## Обновление системы

```bash
cd /etc/nixos

# Обновить flake.lock
sudo nix flake update

# Применить конфигурацию
sudo nixos-rebuild switch --flake .#nixos
```

## Горячие клавиши Hyprland

| Клавиши | Действие |
|---------|----------|
| `Super + Enter` | Терминал (Kitty) |
| `Super + D` | Лаунчер (Wofi) |
| `Super + Q` | Закрыть окно |
| `Super + F` | Полный экран |
| `Super + V` | Плавающее окно |
| `Super + L` | Заблокировать экран |
| `Super + 1-0` | Рабочий стол 1-10 |
| `Super + Shift + 1-0` | Переместить окно |
| `Super + стрелки` | Переключить фокус |
| `Print` | Скриншот области |
| `Shift + Print` | Скриншот всего экрана |
| `Alt + Shift` | Переключить раскладку (us/ru) |

## Что включено

- **WM**: Hyprland (Wayland tiling compositor)
- **Bar**: Waybar
- **Launcher**: Wofi
- **Terminal**: Kitty (FiraCode Nerd Font)
- **Audio**: PipeWire
- **Lock**: Hyprlock + Hypridle
- **DM**: greetd + tuigreet

## После установки

1. Добавь обои: `~/.config/hypr/wallpaper.png`
2. Настрой git email в `home.nix`
3. Установи дополнительные пакеты по необходимости
