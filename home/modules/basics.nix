{ lib, pkgs, config, inputs, ... }:

{
  imports = [
    inputs.sops-nix.homeManagerModules.sops
    "${inputs.private}/git.nix"
    "${inputs.private}/ssh.nix"
  ];
  home.packages = with pkgs; [
    sops
    git-graph
    gnupg
    neofetch
    ddcutil
    ddcui
    unzip
    ripgrep
    isync
    libnotify
    jq
    sshfs
    libusb1
    usbutils
    appimage-run
    imagemagick
    poppler-utils
    ffmpeg
    speedtest-cli
    exiftool
    file
    zip
    nix-diff
    # gcr ?
    radeontop
    # flatpak
  ];

  xdg.mimeApps.enable = true; # actual applications are defined in modules
  services.clipman.enable = true;
  services.gnome-keyring.enable = true;
  programs.ssh.enable = true;

  services.flatpak = {
    enable = true;
    update.onActivation = true;
    packages = [
      "com.stremio.Stremio"
    ];
  };

# BTOP
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "gruvbox_dark";
    };
  };

# GIT
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Joshua Jeschek";
        email = "dev@jeschek.eu";
      };
      alias = {
        tree = "! git ls-tree -r --name-only HEAD | tree --fromfile";
        amend = "commit --amend --no-edit";
        change-commits = "\"!f() { VAR=$1; OLD=$2; NEW=$3; shift 3; git filter-branch --env-filter \"if [[ \\\"$`echo $VAR`\\\" = '$OLD' ]]; then export $VAR='$NEW'; fi\" $@; }; f\"";
        kdiff = "difftool --no-symlinks --dir-diff";
        fpush = "push --force-with-lease --force-if-includes";
        graph = "log --graph --oneline";
        sync = "! git add . && git commit -m 'sync' && git pull --rebase && git push";
        shash = "rev-parse --short=9";
        copy-commit = "!f() { git --git-dir=\"$1/.git\" format-patch -k -1 --stdout \"$2\" | git am -3 -k; }; f"; # copy the commit $2 from the repo $1 to the current repo - https://stackoverflow.com/a/9507417
      };
      core.editor = "nvim";
    };
    ignores = [
      ".direnv/"
      # "shell.nix"
    ];
    includes = [
      {
        contents = {
          user.signingkey = "~/.ssh/id_ed25519";
          gpg.format = "ssh";
          commit.gpgsign = true;
          init.defaultBranch = "main";
          checkout.defaultRemote = "origin";
          rerere.enable = true;
          push.autoSetupRemote = true;
          diff = {
            tool = "kitty";
            guitool = "kitty.gui";
          };
          difftool = {
            prompt = false;
            trustExitCode = true;
            kitty = {
              cmd = "kitten diff $LOCAL $REMOTE";
            };
            "kitty.gui" = {
              cmd = "kitten diff $LOCAL $REMOTE";
            };
          };
        };
      }
    ];
  };

# SOPS
  sops = {
    defaultSopsFile = "${inputs.private}/secrets.yaml";
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };
}
