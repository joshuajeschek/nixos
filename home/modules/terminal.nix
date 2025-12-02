{ lib, pkgs, ... }:
let
  zsh-wakatime = pkgs.fetchFromGitHub {
    owner = "wbingli";
    repo = "zsh-wakatime";
    rev = "98a877680cbf4a2360df7fa0ffc38b6f2b5cd1a0";
    sha256 = "sha256-iMHPDz4QvaL3YdRd3vaaz1G4bj8ftRVD9cD0KyJVeAs=";
  };
in
{
  home.packages = with pkgs; [
    tealdeer
    bat
    fx
  ];

# KITTY
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
    ".config/kitty/diff.conf".source = ./files/kitty-diff.conf;
  };

# AUTOJUMP
  programs.autojump = {
    enable = true;
    enableZshIntegration = true;
  };

# ZSH
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "agnoster";
    };
    initContent = ''
      source ${zsh-wakatime}/zsh-wakatime.plugin.zsh;
    '';
    shellAliases = {
      h = "history";
      please = "sudo";
      dog = "cat";
      more = "less";
      open = "xdg-open";
      nivm = "nvim";
      nmt = "neomutt && ((pgrep mbsync && pkill mbsync) || exit 0)";
      zshcfg = "nvim ~/.zshrc && source ~/.zshrc";
      kittycfg = "nvim ~/.config/kitty/kitty.conf";
      kk = "vdirsyncer -v WARNING sync google; khal interactive; (vdirsyncer -v WARNING sync google &)";
      den = "code ~/dendron/dendron.code-workspace";
      backup-config = "mackup backup && ~/dotfiles/sync.sh";
      save-command = "source ~/.scripts/save-command.sh";
      zshfetch = "neofetch; zsh";
      s = "kitty +kitten ssh";
      icat = "kitten icat";
      c = "wl-copy";
      v = "wl-paste";
      hg = "history | grep";
      sb = "sudo ddcutil -d 1 setvcp 10";
      SHUTDOWN = "shutdown -h now";
      timesync = "sudo ntpd -qg && sudo hwclock --systohc";
      remake = "make clean && make";
    };
  };

# STARSHIP
  programs.starship = {
    enable = true;
    settings = {
      format = "$character";
      right_format = ''
        $jobs
        $cmd_duration
        $conda
        $haskell
        $git_state
        $git_status
        $git_branch
        $directory
      '';
      palette = "main";
      add_newline = false;
      command_timeout = 1000;
      directory = {
        format = "[ ](bg)[$path ](bg:bg)[](fg:dir bg:bg)[](bg:dir)[](dir)";
        truncation_length = 3;
        truncate_to_repo = false;
        truncation_symbol = "…/";
      };
      git_status = {
        format = "[ ](bg)[$all_status](bg:bg)[$ahead_behind ](bg:bg fg:red)";
      };
      git_state = {
        format = "[$state ($progress_current of $progress_total) ](bg:bg)";
      };
      git_branch = {
        symbol = "";
        format = "[$branch ](bg:bg)[](fg:git bg:bg)[$symbol](bg:git)[](git)";
      };
      cmd_duration = {
        min_time = 1;
        format = "[ ](bg)[$duration ](bg:bg)[](fg:dur bg:bg)[󰚭](bg:dur)[](dur)";
      };
      jobs = {
        symbol = "";
      };
      fill = {
        symbol = " ";
      };
      haskell = {
        symbol = "";
        format = "[ ](bg)[$version ](bg:bg)[](fg:lng bg:bg)[$symbol](bg:lng)[](lng)";
      };
      conda = {
        symbol = "";
        format = "[ ](bg)[$environment ](bg:bg)[](fg:lng bg:bg)[$symbol](bg:lng)[](lng)";
      };
      palettes.main = {
        bg = "#3C3836";
        dir = "#7C8E76";
        git = "#448488";
        dur = "#B16185";
        lng = "#689D69";
      };
    };
  };

# DIRENV
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      global.hide_env_diff = true;
    };
  };

}


