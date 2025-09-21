{ config, pkgs, inputs, ... }:

let
  wallpaper = pkgs.fetchurl {
    url = "https://cloud.jeschek.eu/s/6MJ6kZ3itQ5Ea73/download/rivendell.png";
    hash = "sha256-AE3wqoOKXyWsoeUFsVlYqTPDkqpAsQdk3k7qGAn0cmc=";
  };
  screenshotDir = "${config.home.homeDirectory}/Pictures/Screenshots";
  lr = layer: rules: builtins.map (rule: "${rule},${layer}") rules;

  emailShorthands = (import "${inputs.private}/_email.nix").shorthands;
  generateEnvFiles = emailShorthands:
    builtins.listToAttrs (
      map (shorthand: {
        name = ".config/waybar-extra/" + shorthand + ".env";
        value = {
          text = "#!/usr/bin/env bash\nexport ADDRESS='" + emailShorthands.${shorthand} + "'\n";
        };
      }) (builtins.attrNames emailShorthands)
    );
in

{
  imports = [ ./binds.nix ];

  home.file = {
    ".config/swayosd/style.css".source = ./files/swayosd.css;
    ".local/share/icons/bibata-sage".source = ./files/bibata-sage;
    ".config/dunst/dunstrc".source = ./files/dunstrc;
    ".config/eww".source = ./files/eww;
    ".config/waybar".source = ./files/waybar;
  } // (generateEnvFiles emailShorthands);

  home.sessionVariables = {
    HYPRSHOT_DIR = screenshotDir;
  };

  gtk.theme = "Adwaita:dark";

  home.packages = with pkgs; [
    hyprland-qtutils
    wl-clipboard
    hyprpicker
    hyprshot
    grimblast
    nemo
    bemoji
    hyprcursor
    playerctl
    dunst
    eww
    pamixer
    swaynotificationcenter
    # pinentry-rofi ?
  ];

# HYPRLAND
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      workspace = [
        "1, monitor:DP-1, default:true"
        "2, monitor:DP-1, default:true"
        "3, monitor:DP-1, default:true"
        "4, monitor:DP-1, default:true"
        "5, monitor:DP-1, default:true"
        "6, monitor:HDMI-A-1, default:true"
        "7, monitor:HDMI-A-1, default:true"
        "8, monitor:HDMI-A-1, default:true"
        "9, monitor:HDMI-A-2, default:true"
        "6, vesktop"
        "9, stremio"
      ];
      monitor = [
        "HDMI-A-1, 1920x1080@60,  -1080x-250, 1, transform,1"
        "DP-1,     3440x1440@100, 0x0,        1"
        # "HDMI-A-2, 3840x2160@60,  573x-1440,  1.5, bitdepth,10, cm,hdr, sdrbrightness,1, sdrsaturation, 1.5"
        "HDMI-A-2, 3840x2160@60,  573x-1440,  1.5, bitdepth,10"
        # landscape second screen
        # "HDMI-A-1,1920x1080@60,0x0,1"
        # "DP-1,3440x1440@100,1920x250,1"
      ];
      env = [
        "GTK_THEME,Adwaita:dark"
        "HYPRCURSOR_THEME,Bibata Sage"
        "HYPRCURSOR_SIZE,20"
        "XCURSOR_THEME,bibata-sage"
        "XCURSOR_SIZE,20"
      ];
      exec-once = [
        "~/.config/eww/scripts/init"
        "waybar"
        "wl-paste --watch 'clipman store --max-items=0'"
      ];
      input = {
        kb_layout = "de";
        kb_variant = "nodeadkeys";
        kb_options = "caps:escape";
        follow_mouse = 2;
        sensitivity = -0.2;
      };
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        "col.active_border" = "rgba(ffffff99)";
        layout = "dwindle";
      };
      group = {
        "col.border_active" = "rgba(7c8e76ff)";
        "col.border_inactive" = "rgba(7c8e76aa)";
        groupbar = {
          font_size = 10;
          text_color = "rgba(ebdbb2ff)";
          "col.active" = "rgba(7c8e76ff)";
          "col.inactive" = "rgba(7c8e76aa)";
        };
      };
      cursor = {
        no_hardware_cursors = false;
        inactive_timeout = 0;
        persistent_warps = true;
      };
      misc = {
        font_family = "CaskaydiaCove Nerd Font Mono";
        disable_hyprland_logo = true;
      };
      decoration = {
        rounding = 20;
        blur = {
            size = 5;
            xray = false;
            noise = 0.15;
            brightness = 0.65;
            passes = 2;
        };
        active_opacity = 1.0;
        inactive_opacity = 1.0;
        dim_inactive = false;
        dim_strength = 0.1;
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };
      animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
	          "windows, 1, 5, myBezier"
            "windowsOut, 1, 5, default, popin 80%"
            "border, 1, 10, default"
            "fade, 1, 7, default"
            "workspaces, 1, 3, default"
	  ];
      };
      dwindle = {
          pseudotile = true;
          preserve_split = true;
          force_split = 2;
      };
      master = {
          new_status = "inherit";
      };
      layerrule =
        (lr "launcher" ["blur" "ignorezero" "dimaround" "xray 1"])
        ++ (lr "waybar" ["blur" "ignorezero" "ignorealpha 0.3"])
        ++ (lr "notifications" ["blur" "ignorezero"])
        ++ (lr "swayosd" ["blur" "ignorezero"])
        ++ (lr "selection" ["noanim"])
        ++ (lr "hyprpicker" ["noanim"]);
      render = {
        cm_fs_passthrough = 1;
      };
      # ecosystem = {
      #   enforce_permissions = true;
      # };
      # permission = [
      #   "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland, screencopy, allow"
      # ];
    };
  };

# HYPRPAPER
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      preload = [
        (builtins.toString wallpaper)
      ];

      wallpaper = [
        "HDMI-A-1,${builtins.toString wallpaper}"
        "HDMI-A-2,${builtins.toString wallpaper}"
        "DP-1,${builtins.toString wallpaper}"
        "DP-2,${builtins.toString wallpaper}"
      ];
    };
  };

# WAYBAR
  programs.waybar.enable = true;

# FUZZEL
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        width = 50;
        show-actions = true;
      };
      colors = {
        text            = "EBDBB2FF";
        match           = "EBDBB2FF";
        selection-text  = "EBDBB2FF";
        selection-match = "D79920FF";
        background      = "00000055";
        selection       = "7C8E76ff";
        border          = "ffffff99";
      };
      border = {
        width = 2;
      };
    };
  };

# SWAYOSD
  services.swayosd = {
    enable = true;
    topMargin = 0.1;
  };
}

