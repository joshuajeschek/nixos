{
  programs.autojump = {
    enable = true;
    enableZshIntegration = true;
  };
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
}
