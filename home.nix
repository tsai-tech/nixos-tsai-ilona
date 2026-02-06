{ config, pkgs, ... }:

{
  imports = [
    ./home/hyprland.nix
    ./home/waybar.nix
  ];

  home.username = "leet";
  home.homeDirectory = "/home/leet";
  home.stateVersion = "25.11";

  # ===========================================================================
  # ПЕРЕМЕННЫЕ ОКРУЖЕНИЯ
  # ===========================================================================
  home.sessionVariables = {
    CHROME_EXECUTABLE = "${pkgs.chromium}/bin/chromium";
  };

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
      user.name = "Mikhail Tsai";
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
    initExtra = ''
      # fnm — переключение версий Node.js
      eval "$(fnm env --use-on-cd)"
    '';
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
      nodejs = {
        symbol = " ";
      };
      rust = {
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
    # Node.js — управление версиями (fnm install --lts)
    fnm

    # Шпаргалка по хоткеям (Super+/)
    (writeShellScriptBin "keybinds" ''
      C='\033[36m'    # cyan
      Y='\033[33m'    # yellow
      B='\033[1m'     # bold
      R='\033[0m'     # reset
      H="''${B}''${C}" # header

      echo ""
      echo "''${H}  ─── ПРИЛОЖЕНИЯ ───''${R}"
      echo "  ''${Y}Super+Enter''${R}        Терминал"
      echo "  ''${Y}Super+D''${R}            Лаунчер"
      echo "  ''${Y}Super+R''${R}            Запуск команды"
      echo "  ''${Y}Super+E''${R}            Файлы"
      echo "  ''${Y}Super+B''${R}            Firefox"
      echo "  ''${Y}Super+L''${R}            Блокировка"
      echo "  ''${Y}Super+M''${R}            Меню выхода"
      echo "  ''${Y}Super+Shift+M''${R}      Выход из Hyprland"
      echo ""
      echo "''${H}  ─── ОКНА ───''${R}"
      echo "  ''${Y}Super+Q''${R}            Закрыть окно"
      echo "  ''${Y}Super+V''${R}            Плавающее"
      echo "  ''${Y}Super+F''${R}            Полный экран"
      echo "  ''${Y}Super+Shift+F''${R}      Максимизация"
      echo "  ''${Y}Super+T''${R}            Поверх всех"
      echo "  ''${Y}Super+C''${R}            Центрировать"
      echo "  ''${Y}Super+P''${R}            Pseudo-tile"
      echo "  ''${Y}Super+J''${R}            Переключить split"
      echo "  ''${Y}Super+G''${R}            Группа окон"
      echo "  ''${Y}Super+Tab''${R}          След. в группе"
      echo ""
      echo "''${H}  ─── ФОКУС / ПЕРЕМЕЩЕНИЕ ───''${R}"
      echo "  ''${Y}Super+←↑↓→''${R}        Фокус"
      echo "  ''${Y}Super+H/K  Alt+J''${R}   Фокус (vim)"
      echo "  ''${Y}Alt+Tab''${R}            Циклический фокус"
      echo "  ''${Y}Super+Shift+←↑↓→''${R}  Переместить окно"
      echo "  ''${Y}Super+Shift+HJKL''${R}   Переместить (vim)"
      echo "  ''${Y}Super+Ctrl+←↑↓→''${R}   Размер окна"
      echo "  ''${Y}Super+Ctrl+HJKL''${R}    Размер (vim)"
      echo "  ''${Y}Ctrl+Shift+←↑↓→''${R}   Swap с соседом"
      echo ""
      echo "''${H}  ─── РАБОЧИЕ СТОЛЫ ───''${R}"
      echo "  ''${Y}Super+1-0''${R}          Переключить 1-10"
      echo "  ''${Y}Super+Shift+1-0''${R}    Переместить окно"
      echo "  ''${Y}Super+Alt+1-5''${R}      Переместить тихо"
      echo "  ''${Y}Super+[ ]''${R}          Пред./след."
      echo "  ''${Y}Super+Колесо''${R}       Прокрутка столов"
      echo "  ''${Y}Super+S''${R}            Scratchpad"
      echo "  ''${Y}Super+Shift+S''${R}      В scratchpad"
      echo ""
      echo "''${H}  ─── СКРИНШОТЫ ───''${R}"
      echo "  ''${Y}Print''${R}              Область → буфер"
      echo "  ''${Y}Shift+Print''${R}        Экран → буфер"
      echo "  ''${Y}Super+Print''${R}        Область → Swappy"
      echo "  ''${Y}Super+Shift+Print''${R}  Экран → Swappy"
      echo "  ''${Y}Alt+Print''${R}          Окно → буфер"
      echo ""
      echo "''${H}  ─── УТИЛИТЫ ───''${R}"
      echo "  ''${Y}Super+X''${R}            История буфера"
      echo "  ''${Y}Super+Shift+C''${R}      Пипетка цвета"
      echo "  ''${Y}Super+/''${R}            Эта шпаргалка"
      echo "  ''${Y}Alt+Shift''${R}          Раскладка US/RU"
      echo ""
      echo "''${H}  ─── МЫШЬ ───''${R}"
      echo "  ''${Y}Super+ЛКМ''${R}          Перетаскивать"
      echo "  ''${Y}Super+ПКМ''${R}          Изменить размер"
      echo ""
      read -n 1 -s -r
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

    # Дополнительные шрифты для терминала
    nerd-fonts.symbols-only
  ];

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
      XDG_SCREENSHOTS_DIR = "${config.home.homeDirectory}/Pictures/Screenshots";
    };
  };

  # Создаём директорию для скриншотов
  home.file."Pictures/Screenshots/.keep".text = "";

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
  # WOFI (лаунчер)
  # ===========================================================================
  xdg.configFile."wofi/style.css".text = ''
    window {
      margin: 0px;
      border: 2px solid #33ccff;
      border-radius: 10px;
      background-color: rgba(26, 26, 26, 0.95);
    }

    #input {
      margin: 5px;
      border: none;
      color: #d0d0d0;
      background-color: #2a2a2a;
      border-radius: 5px;
      padding: 10px;
    }

    #inner-box {
      margin: 5px;
      border: none;
      background-color: transparent;
    }

    #outer-box {
      margin: 5px;
      border: none;
      background-color: transparent;
    }

    #scroll {
      margin: 0px;
      border: none;
    }

    #text {
      margin: 5px;
      border: none;
      color: #d0d0d0;
    }

    #entry {
      border-radius: 5px;
    }

    #entry:selected {
      background-color: #33ccff;
      color: #1a1a1a;
    }
  '';
}
