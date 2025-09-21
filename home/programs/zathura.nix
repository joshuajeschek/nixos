{
  programs.zathura = {
    enable = true;
    options = {
      font                  = "CaskaydiaCove Nerd Font Mono 12";
      selection-notification= true;
      selection-clipboard   = "clipboard";
      guioptions            = "sv";
      scroll-page-aware     = true;
      statusbar-home-tilde  = true;
      recolor               = true;
      recolor-keephue       = true;
      adjust-open           = "width";
      statusbar-h-padding   = 10;
      statusbar-v-padding   = 10;
      # zathura gruvbox-dark
      notification-error-bg    = "rgba(0,0,0,0.5)"; # bg
      notification-error-fg    = "#fb4934"; # bright:red
      notification-warning-bg  = "rgba(0,0,0,0.5)"; # bg
      notification-warning-fg  = "#fabd2f"; # bright:yellow
      notification-bg          = "rgba(0,0,0,0.5)"; # bg
      notification-fg          = "#b8bb26"; # bright:green

      completion-bg            = "rgba(64,64,64,0.5)"; # bg2
      completion-fg            = "#ebdbb2"; # fg
      completion-group-bg      = "rgba(32,32,32,0.5)"; # bg1
      completion-group-fg      = "#928374"; # gray
      completion-highlight-bg  = "#83a598"; # bright:blue
      completion-highlight-fg  = "rgba(64,64,64,0.5)"; # bg2

      # Define the color in index mode
      index-bg                 = "rgba(64,64,64,0.5)"; # bg2
      index-fg                 = "#ebdbb2"; # fg
      index-active-bg          = "#83a598"; # bright:blue
      index-active-fg          = "rgba(64,64,64,0.5)"; # bg2

      inputbar-bg              = "rgba(48,48,48,0.25)"; # bg
      inputbar-fg              = "#ebdbb2"; # fg

      statusbar-bg             = "rgba(64,64,64,0.5)"; # bg2
      statusbar-fg             = "#ebdbb2"; # fg

      highlight-color          = "#fabd2f"; # bright:yellow
      highlight-active-color   = "#fe8019"; # bright:orange

      default-bg               = "rgba(0,0,0,0.4)"; # bg
      default-fg               = "#ebdbb2"; # fg
      render-loading           = true;
      render-loading-bg        = "rgba(0,0,0,0.4)"; # bg
      render-loading-fg        = "#ebdbb2"; # fg

      # Recolor book content's color
      recolor-lightcolor       = "rgba(0,0,0,0)"; # bg
      recolor-darkcolor        = "#ebdbb2"; # fg
    };
    mappings = {
      "1" = "set 'recolor-darkcolor \"#ffffff\"'";
      "2" = "set 'recolor-lightcolor \"#000000\"'";
      "4" = "set 'recolor-darkcolor \"#ebdbb2\"'";
      "5" = "set 'recolor-lightcolor \"rgba(0,0,0,0)\"'";
      "<F1>" = "feedkeys '12'";
      "<F2>" = "feedkeys '45'";
    };
  };
}
