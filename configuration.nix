{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  programs.ssh.startAgent = true;

  # VMware guest additions
  virtualisation.vmware.guest.enable = true;
  services.openssh.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  hardware.graphics.enable = true;

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "America/Montevideo";

  # Locales
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_UY.UTF-8";
    LC_IDENTIFICATION = "es_UY.UTF-8";
    LC_MEASUREMENT = "es_UY.UTF-8";
    LC_MONETARY = "es_UY.UTF-8";
    LC_NAME = "es_UY.UTF-8";
    LC_NUMERIC = "es_UY.UTF-8";
    LC_PAPER = "es_UY.UTF-8";
    LC_TELEPHONE = "es_UY.UTF-8";
    LC_TIME = "es_UY.UTF-8";
  };

  users.users.mikhailtsai = {
    isNormalUser = true;
    description = "Mikhail Tsai";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    kitty
    git
    open-vm-tools
    waybar
    wofi
    pavucontrol
    hyprpaper
    hyprlock
    hypridle
  ];

  # PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Hyprland
  programs.hyprland.enable = true;

  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
        lock_cmd = hyprlock
        before_sleep_cmd = hyprlock
        after_sleep_cmd = hyprlock
    }

    listener {
        timeout = 1200
        on-timeout = hyprlock
    }

    listener {
        timeout = 3600
        on-timeout = systemctl suspend
    }
  '';

  xdg.configFile."hypr/hyprland.conf".text = ''
    $mod = SUPER
    bind = $mod, RETURN, exec, kitty
    monitor = ,preferred,auto,1
    exec-once = waybar
    exec-once = nm-applet
    exec-once = hyprpaper
  '';

  xdg.configFile."kitty/kitty.conf".text = ''
    background_opacity 0.9

    foreground #d0d0d0
    background #1a1a1a

    font_family      FiraCode Nerd Font
    font_size        12.0

    cursor_shape     block
    cursor_blink     yes

    scrollback_lines 5000

    map ctrl+shift+t new_tab
    map ctrl+shift+w close_tab
    map ctrl+shift+enter new_window
  '';

  # greetd (автологин в Hyprland)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.gtkgreet}/bin/gtkgreet";
        user = "mikhailtsai";
      };
    };
  };

  system.stateVersion = "25.11";
}