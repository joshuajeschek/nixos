{ lib, ... }:
{
  programs.kitty = lib.mkForce {
    enable = true;
    settings = {
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      font_size = 12;
      text_composition_strategy = "legacy";
      cursor_shape = "beam";
      url_style = "straight";
      strip_trailing_spaces = "smart";
      window_padding_width = "6 1";
      background_opacity = "0.2";
      # gruvbox-dark colorscheme for kitty
      # snazzy theme used as base
      # https://gist.github.com/lunks/0d5731693084b2831c88ca23936d20e8
      foreground           = "#ebdbb2";
      background           = "#000000";
      selection_foreground = "#655b53";
      selection_background = "#ebdbb2";
      url_color            = "#d65c0d";
      # black
      color0  = "#000000";
      color8  = "#928373";
      # red
      color1  = "#cc231c";
      color9  = "#fb4833";
      # green
      color2  = "#989719";
      color10 = "#b8ba25";
      # yellow
      color3  = "#d79920";
      color11 = "#fabc2e";
      # blue
      color4  = "#448488";
      color12 = "#83a597";
      # magenta
      color5  = "#b16185";
      color13 = "#d3859a";
      # cyan
      color6  = "#7c8e76";
      color14 = "#98a394";
      # white
      color7  = "#a89983";
      color15 = "#ebdbb2";
    };
  };
  home.file = {
    ".config/kitty/diff.conf".source = ./diff.conf;
  };
}

