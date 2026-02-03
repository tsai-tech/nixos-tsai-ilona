{ config, pkgs, ... }:

{
  # Waybar - конфигурация
  xdg.configFile."waybar/config".text = builtins.toJSON {
    layer = "top";
    position = "top";
    height = 30;
    modules-left = [ "hyprland/workspaces" "hyprland/window" ];
    modules-center = [ "clock" ];
    modules-right = [ "pulseaudio" "network" "battery" "tray" ];

    "hyprland/workspaces" = {
      format = "{icon}";
      on-click = "activate";
    };

    clock = {
      format = "{:%H:%M}";
      format-alt = "{:%Y-%m-%d}";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    };

    battery = {
      states = {
        warning = 30;
        critical = 15;
      };
      format = "{capacity}% {icon}";
      format-icons = [ "" "" "" "" "" ];
    };

    network = {
      format-wifi = "{essid} ";
      format-ethernet = "{ipaddr} ";
      format-disconnected = "Disconnected ⚠";
    };

    pulseaudio = {
      format = "{volume}% {icon}";
      format-muted = "";
      format-icons = {
        default = [ "" "" "" ];
      };
      on-click = "pavucontrol";
    };

    tray = {
      spacing = 10;
    };
  };

  # Waybar - стили
  xdg.configFile."waybar/style.css".text = ''
    * {
      font-family: "FiraCode Nerd Font";
      font-size: 13px;
    }

    window#waybar {
      background-color: rgba(26, 26, 26, 0.9);
      color: #d0d0d0;
      border-bottom: 2px solid rgba(51, 204, 255, 0.5);
    }

    #workspaces button {
      padding: 0 5px;
      color: #d0d0d0;
      background: transparent;
      border: none;
    }

    #workspaces button.active {
      color: #33ccff;
    }

    #clock, #battery, #network, #pulseaudio, #tray {
      padding: 0 10px;
    }

    #battery.warning {
      color: #ffcc00;
    }

    #battery.critical {
      color: #ff3333;
    }
  '';
}
