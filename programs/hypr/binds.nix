{
  wayland.windowManager.hyprland = {
    settings = {
      "$mod" = "SUPER";
      bind = [
	      # misc
        "$mod, I, exec, kitty"
        "$mod, Q, killactive"
        "$mod SHIFT CTRL, END, exit"
        "$mod, SPACE, exec, fuzzel"
        "$mod SHIFT, C, exec, hyprpicker --autocopy && notify-send -a hyprpicker \"$(wl-paste)\""
	      "$mod, E, exec, nemo"
	      "$mod, F, togglefloating,"
	      "$mod, M, fullscreen, 1"
	      "$mod SHIFT, M, fullscreen, 0"
	      "$mod CTRL, E, exec, BEMOJI_PICKER_CMD=\"fuzzel -d\" bemoji"
	      "$mod, V, exec, clipman pick --max-items=0 --tool=CUSTOM --tool-args=\"fuzzel -d\""
        # ",PRINT, exec, grimblast --notify copysave area ${screenshot.dir}/${screenshot.name}"
        ", PRINT, exec, hyprshot --freeze -m region"
        #"$mod, PRINT, exec, hyprshot -m output"
        #"$mod SHIFT, PRINT, exec, hyprshot -m window"

	      # focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"
	      # group
        "$mod, S, togglegroup,"
        "$mod, TAB, changegroupactive, f"
        "$mod SHIFT, TAB, changegroupactive, b"
        "$mod CTRL, h, moveoutofgroup, l"
        "$mod CTRL, l, moveoutofgroup, r"
        "$mod CTRL, k, moveoutofgroup, u"
        "$mod CTRL, j, moveoutofgroup, d"
        "$mod CTRL, h, moveintogroup, l"
        "$mod CTRL, l, moveintogroup, r"
        "$mod CTRL, k, moveintogroup, u"
        "$mod CTRL, j, moveintogroup, d"
	      # window
        "$mod CTRL, h, movewindow, l"
        "$mod CTRL, l, movewindow, r"
        "$mod CTRL, k, movewindow, u"
        "$mod CTRL, j, movewindow, d"
        # split
        "$mod, P, pseudo," # dwindle
        "$mod, O, togglesplit," # dwindle
	      # workspace (scroll)
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ]
      ++ ( # workspaces
        builtins.concatLists (builtins.genList (i:
          let ws = i + 1;
          in [
            "$mod, code:1${toString i}, workspace, ${toString ws}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
          ]
        )
	      9)
      );
      binde = [
	      # window
        "$mod SHIFT, left, resizeactive, -10 0"
        "$mod SHIFT, right, resizeactive, 10 0"
        "$mod SHIFT, up, resizeactive, 0 -10"
        "$mod SHIFT, down, resizeactive, 0 10"
        "$mod SHIFT, h, resizeactive, -10 0"
        "$mod SHIFT, l, resizeactive, 10 0"
        ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
        ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
        ", XF86AudioPlay, exec, playerctl play-pause"
      ];
      bindm = [
        # window
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };
}
