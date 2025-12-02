# { config, pkgs, inputs, ... }:

{
# WALKER
  programs.walker = {
    enable = true;
    runAsService = true; # Note: this option isn't supported in the NixOS module only in the home-manager module

    # All options from the config.toml can be used here https://github.com/abenz1267/walker/blob/master/resources/config.toml
    config = {
      theme = "blur";
      placeholders."default" = { input = "Search"; list = "¯\\_(ツ)_/¯"; };
      providers = {
        default = [
          "desktopapplications"
          "calc"
          "websearch"
          "files"
        ];
        empty = ["desktopapplications"];
        prefixes = [
          { prefix = "?"; provider = "websearch"; }
          { prefix = ":"; provider = "symbols"; }
          { prefix = " "; provider = "providerlist"; }
          { prefix = ">"; provider = "runner"; }
          { prefix = "/"; provider = "files"; }
          { prefix = "="; provider = "calc"; }
          { prefix = "+"; provider = "clipboard"; }
        ];
      };
      # builtins = {
        # xdph_picker = {
        #   name = "xdphpicker";
        #   placeholder = "Screen/Window Picker";
        #   switcher_only = true;
        #   show_sub_when_single = true;
        #   hidden = true;
        # };
      # };
      keybinds.quick_activate = [ ];
    };

    # Set `programs.walker.config.theme="your theme name"` to choose the default theme
    themes = {
      "blur" = {
        # Check out the default css theme as an example https://github.com/abenz1267/walker/blob/master/resources/themes/default/style.css
        style = ''
          @define-color window_bg_color rgba(0, 0, 0, 0.33);
          @define-color accent_bg_color rgba(255, 255, 255, 0.1);
          @define-color theme_fg_color #ffffff;

          * {
            all: unset;
            font-family: monospace;
          }

          .box-wrapper {
            background: @window_bg_color;
            padding: 15px;
            border-radius: 20px;
            border: 2px solid rgba(255, 255, 255, 0.6);
          }

          .input {
            background: @accent_bg_color;
            color: @theme_fg_color;
            padding: 10px;
            border-radius: 8px;
          }

          .item-box {
            padding: 10px;
            border-radius: 8px;
          }

          child:selected .item-box {
            background: rgba(255, 255, 255, 0.2);
          }

          '';
      };
    };
  };

# ELEPHANT
  programs.elephant = {
    enable = true;
    provider.websearch.settings = {
      entries = [
        {
          name = "Ecosia";
          url = "https://www.ecosia.org/search?q=%TERM%";
          default = true;
          icon = "ecosia";
        }
        {
          name = "Home Manager Options";
          url = "https://home-manager-options.extranix.com/?query=%TERM%";
          default = true;
          icon = "home-manager";
        }
        {
          name = "Nix Packages";
          url = "https://search.nixos.org/packages?query=%TERM%";
          default = true;
          icon = "nixos";
        }
      ];
    };
    provider.desktopapplications.settings = {
      show_actions = true;
    };
    provider.xdph_picker.settings = {
      name = "xdphpicker";
      placeholder = "Screen/Window Picker";
      switcher_only = true;
      show_sub_when_single = true;
      hidden = true;
    };
  };

}
