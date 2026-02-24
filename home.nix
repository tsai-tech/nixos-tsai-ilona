{ config, pkgs, lib, ... }:

{
  imports = [
    ./home/hyprland.nix
    ./home/waybar.nix
  ];

  home.username = "ilona";
  home.homeDirectory = "/home/ilona";
  home.stateVersion = "25.11";

  # ===========================================================================
  # ПЕРЕМЕННЫЕ ОКРУЖЕНИЯ
  # ===========================================================================
  home.sessionVariables = {
    GDK_DPI_SCALE = "1.25";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # Позволяем Home Manager управлять собой
  programs.home-manager.enable = true;

  # ===========================================================================
  # ТЕРМИНАЛ — Kitty
  # ===========================================================================
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.9";
      foreground = "#d0d0d0";
      background = "#1a1a1a";
      font_family = "FiraCode Nerd Font";
      font_size = "12.0";
      cursor_shape = "block";
      cursor_blink_interval = "0.5";
      scrollback_lines = 10000;
      enable_audio_bell = false;
      window_padding_width = 8;
      confirm_os_window_close = 0;
    };
  };

  # ===========================================================================
  # GIT
  # ===========================================================================
  programs.git = {
    enable = true;
    settings = {
      user.name = "Ilona Tsai";
      user.email = ""; # Добавь свой email
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "code --wait";
    };
  };

  # ===========================================================================
  # BASH
  # ===========================================================================
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      la = "ls -A";
      l = "ls -CF";
      ".." = "cd ..";
      "..." = "cd ../..";
      update = "sudo nixos-rebuild switch --flake .";
      gs = "git status";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
    };
  };

  # ===========================================================================
  # STARSHIP (prompt)
  # ===========================================================================
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      git_branch = {
        symbol = " ";
      };
      python = {
        symbol = " ";
      };
    };
  };

  # ===========================================================================
  # ДОПОЛНИТЕЛЬНЫЕ ПАКЕТЫ ПОЛЬЗОВАТЕЛЯ
  # ===========================================================================
  home.packages = with pkgs; [
    # Шпаргалка по хоткеям (Super+/)
    (writeShellScriptBin "keybinds" ''
      C='\033[36m'    # cyan
      Y='\033[33m'    # yellow
      B='\033[1m'     # bold
      R='\033[0m'     # reset
      G='\033[90m'    # gray

      clear
      printf "\n"
      printf "''${B}''${C}  ══════════════════════════════════════════════════════════════════════''${R}\n"
      printf "''${B}''${C}                        ГОРЯЧИЕ КЛАВИШИ HYPRLAND''${R}\n"
      printf "''${B}''${C}  ══════════════════════════════════════════════════════════════════════''${R}\n"
      printf "\n"
      printf "''${B}  ПРИЛОЖЕНИЯ                                 ОКНА''${R}\n"
      printf "  ''${Y}Super + Enter''${R}          Терминал            ''${Y}Super + Q''${R}              Закрыть\n"
      printf "  ''${Y}Super + D''${R}              Rofi                ''${Y}Super + V''${R}              Плавающее\n"
      printf "  ''${Y}Super + E''${R}              Файлы               ''${Y}Super + F''${R}              Полный экран\n"
      printf "  ''${Y}Super + B''${R}              Firefox             ''${Y}Super + T''${R}              Поверх всех\n"
      printf "  ''${Y}Super + L''${R}              Блокировка          ''${Y}Super + C''${R}              Центрировать\n"
      printf "  ''${Y}Super + M''${R}              Меню выхода         ''${Y}Super + G''${R}              Группа окон\n"
      printf "\n"
      printf "''${B}  РАБОЧИЕ СТОЛЫ                              НАВИГАЦИЯ''${R}\n"
      printf "  ''${Y}Super + 1-0''${R}            Переключить         ''${Y}Super + Стрелки''${R}        Фокус\n"
      printf "  ''${Y}Super + Shift + 1-0''${R}    Переместить         ''${Y}Super + Shift + Стр''${R}    Переместить\n"
      printf "  ''${Y}Super + S''${R}              Scratchpad          ''${Y}Super + Ctrl + Стр''${R}     Размер\n"
      printf "  ''${Y}Super + [ ]''${R}            Пред./след.         ''${Y}Alt + Tab''${R}              Циклический\n"
      printf "\n"
      printf "''${B}  СКРИНШОТЫ                                  УТИЛИТЫ''${R}\n"
      printf "  ''${Y}Print''${R}                  Область             ''${Y}Super + X''${R}              Буфер обмена\n"
      printf "  ''${Y}Shift + Print''${R}          Весь экран          ''${Y}Super + Shift + C''${R}      Пипетка\n"
      printf "  ''${Y}Super + Print''${R}          Swappy              ''${Y}Super + \\ ''${R}             Пароли\n"
      printf "  ''${Y}Alt + Print''${R}            Активное окно       ''${Y}Super + W''${R}              Обои\n"
      printf "\n"
      printf "''${B}  МЫШЬ                                       ПРОЧЕЕ''${R}\n"
      printf "  ''${Y}Super + ЛКМ''${R}            Перетащить          ''${Y}Alt + Shift''${R}            Раскладка\n"
      printf "  ''${Y}Super + ПКМ''${R}            Размер              ''${Y}Super + /''${R}              Шпаргалка\n"
      printf "  ''${Y}Super + Колесо''${R}         Раб. столы          ''${Y}Fn + клавиши''${R}           Громкость\n"
      printf "\n"
      printf "''${G}                      Нажми любую клавишу для выхода...''${R}\n"
      read -n 1 -s -r
    '')

    # Power menu (rofi)
    (writeShellScriptBin "power-menu" ''
      chosen=$(printf "  Lock\n  Logout\n  Suspend\n  Reboot\n  Shutdown" | rofi -dmenu -i -p "Power" -theme-str '
        window { width: 300px; }
        listview { lines: 5; }
      ')

      case "$chosen" in
        *Lock) hyprlock ;;
        *Logout) hyprctl dispatch exit ;;
        *Suspend) systemctl suspend ;;
        *Reboot) systemctl reboot ;;
        *Shutdown) systemctl poweroff ;;
      esac
    '')

    # CLI утилиты
    eza           # современный ls
    bat           # cat с подсветкой
    delta         # diff для git
    lazygit       # TUI для git
    tldr          # краткие man pages
    zoxide        # умный cd

    # Медиа
    imv           # просмотр изображений

    # Уведомления
    libnotify     # для notify-send

    # Дополнительные шрифты для терминала
    nerd-fonts.symbols-only
  ];

  # ===========================================================================
  # DESKTOP ENTRIES
  # ===========================================================================
  xdg.desktopEntries = {};

  # ===========================================================================
  # ДИРЕКТОРИИ
  # ===========================================================================
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Pictures";
    videos = "${config.home.homeDirectory}/Videos";
    extraConfig = {
      SCREENSHOTS = "${config.home.homeDirectory}/Pictures/Screenshots";
    };
  };

  # Создаём директорию для скриншотов
  home.file."Pictures/Screenshots/.keep".text = "";

  # ===========================================================================
  # WALLPAPER ROTATION (awww)
  # ===========================================================================
  systemd.user.services.wallpaper-rotate = {
    Unit = {
      Description = "Rotate wallpaper using awww";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "oneshot";
      Environment = [
        "WAYLAND_DISPLAY=wayland-1"
        "DISPLAY=:0"
      ];
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.findutils}/bin/find /etc/nixos/wallpapers -type f \\( -name \"*.jpg\" -o -name \"*.png\" -o -name \"*.jpeg\" -o -name \"*.webp\" \\) | ${pkgs.coreutils}/bin/shuf -n 1 | ${pkgs.findutils}/bin/xargs /run/current-system/sw/bin/awww img --transition-type grow --transition-pos center'";
    };
  };

  systemd.user.timers.wallpaper-rotate = {
    Unit = {
      Description = "Rotate wallpaper every 10 minutes";
    };
    Timer = {
      OnUnitActiveSec = "10min";
      OnBootSec = "1min";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };

  # ===========================================================================
  # КУРСОР
  # ===========================================================================
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  # ===========================================================================
  # GTK ТЕМА
  # ===========================================================================
  gtk = {
    enable = true;
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };

  # ===========================================================================
  # QT ТЕМА
  # ===========================================================================
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  # ===========================================================================
  # MAKO (уведомления)
  # ===========================================================================
  services.mako = {
    enable = true;
    settings = {
      default-timeout = 5000;
      border-radius = 10;
      border-size = 2;
      border-color = "#33ccff";
      background-color = "#1a1a1aee";
      text-color = "#d0d0d0";
      font = "FiraCode Nerd Font 11";
      width = 350;
      height = 100;
      margin = 10;
      padding = 15;
      icons = true;
      max-icon-size = 48;
      layer = "overlay";
    };
  };

  # ===========================================================================
  # WLOGOUT (меню выхода)
  # ===========================================================================
  xdg.configFile."wlogout/layout".text = ''
    {
      "label" : "lock",
      "action" : "hyprlock",
      "text" : "Lock",
      "keybind" : "l"
    }
    {
      "label" : "logout",
      "action" : "hyprctl dispatch exit",
      "text" : "Logout",
      "keybind" : "e"
    }
    {
      "label" : "suspend",
      "action" : "systemctl suspend",
      "text" : "Suspend",
      "keybind" : "s"
    }
    {
      "label" : "reboot",
      "action" : "systemctl reboot",
      "text" : "Reboot",
      "keybind" : "r"
    }
    {
      "label" : "shutdown",
      "action" : "systemctl poweroff",
      "text" : "Shutdown",
      "keybind" : "p"
    }
  '';

  xdg.configFile."wlogout/style.css".text = ''
    * {
      background-image: none;
      font-family: "FiraCode Nerd Font";
      font-size: 14px;
    }

    window {
      background-color: rgba(26, 26, 26, 0.9);
    }

    button {
      color: #d0d0d0;
      background-color: #2a2a2a;
      border-radius: 10px;
      border: 2px solid #33ccff;
      margin: 10px;
      background-repeat: no-repeat;
      background-position: center;
      background-size: 25%;
    }

    button:hover {
      background-color: #33ccff;
      color: #1a1a1a;
    }

    button:focus {
      background-color: #33ccff;
      color: #1a1a1a;
    }

    #lock {
      background-image: image(url("/run/current-system/sw/share/wlogout/icons/lock.png"));
    }

    #logout {
      background-image: image(url("/run/current-system/sw/share/wlogout/icons/logout.png"));
    }

    #suspend {
      background-image: image(url("/run/current-system/sw/share/wlogout/icons/suspend.png"));
    }

    #reboot {
      background-image: image(url("/run/current-system/sw/share/wlogout/icons/reboot.png"));
    }

    #shutdown {
      background-image: image(url("/run/current-system/sw/share/wlogout/icons/shutdown.png"));
    }
  '';

  # ===========================================================================
  # NWG-DOCK (начальный набор закреплённых приложений)
  # Илона может менять: правый клик на иконке → Pin/Unpin
  # ===========================================================================
  xdg.configFile."nwg-dock-hyprland/pinned".text = ''
    firefox
    nemo
    telegram-desktop
    spotify
    steam
  '';

  # ===========================================================================
  # SWAPPY (редактор скриншотов)
  # ===========================================================================
  xdg.configFile."swappy/config".text = ''
    [Default]
    save_dir=$HOME/Pictures/Screenshots
    save_filename_format=screenshot-%Y%m%d-%H%M%S.png
    show_panel=true
    line_size=5
    text_size=20
    text_font=FiraCode Nerd Font
    paint_mode=brush
    early_exit=false
    fill_shape=false
  '';

  # ===========================================================================
  # ROFI (лаунчер)
  # ===========================================================================
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "${pkgs.kitty}/bin/kitty";
    theme = "custom";
    extraConfig = {
      modi = "drun,run,window,filebrowser";
      show-icons = true;
      icon-theme = "Papirus-Dark";
      display-drun = " Apps";
      display-run = " Run";
      display-window = " Windows";
      display-filebrowser = " Files";
      drun-display-format = "{name}";
      window-format = "{w} · {c} · {t}";
      font = "FiraCode Nerd Font 12";
      drun-match-fields = "name,generic,exec,categories,keywords";
      drun-categories = "";
      matching = "fuzzy";
      sort = true;
      sorting-method = "fzf";
    };
  };

  xdg.configFile."rofi/custom.rasi".text = ''
    * {
      bg: #1a1a1aee;
      bg-alt: #2a2a2a;
      fg: #d0d0d0;
      fg-alt: #808080;
      accent: #33ccff;
      urgent: #ff6666;

      background-color: transparent;
      text-color: @fg;
      margin: 0;
      padding: 0;
      spacing: 0;
    }

    window {
      width: 600px;
      background-color: @bg;
      border: 2px solid;
      border-color: @accent;
      border-radius: 10px;
    }

    mainbox {
      padding: 12px;
    }

    inputbar {
      background-color: @bg-alt;
      border-radius: 8px;
      padding: 8px 12px;
      spacing: 8px;
      children: [prompt, entry];
    }

    prompt {
      text-color: @accent;
    }

    entry {
      placeholder: "Search...";
      placeholder-color: @fg-alt;
    }

    message {
      margin: 12px 0 0;
      border-radius: 8px;
      background-color: @bg-alt;
    }

    textbox {
      padding: 8px;
    }

    listview {
      lines: 10;
      columns: 1;
      fixed-height: true;
      margin: 12px 0 0;
      spacing: 4px;
    }

    element {
      padding: 8px 12px;
      border-radius: 8px;
      spacing: 12px;
    }

    element normal normal {
      text-color: @fg;
    }

    element normal urgent {
      text-color: @urgent;
    }

    element normal active {
      text-color: @accent;
    }

    element selected {
      background-color: @accent;
    }

    element selected normal, element selected active {
      text-color: #1a1a1a;
    }

    element selected urgent {
      background-color: @urgent;
    }

    element-icon {
      size: 1.2em;
      vertical-align: 0.5;
    }

    element-text {
      text-color: inherit;
      vertical-align: 0.5;
    }
  '';
}
