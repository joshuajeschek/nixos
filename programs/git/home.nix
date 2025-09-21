{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    git-graph
  ];

  programs.git = {
    enable = true;
    userName = "Joshua Jeschek";
    userEmail = "dev@jeschek.eu";
    aliases = {
      tree = "! git ls-tree -r --name-only HEAD | tree --fromfile";
      amend = "commit --amend --no-edit";
      change-commits = "\"!f() { VAR=$1; OLD=$2; NEW=$3; shift 3; git filter-branch --env-filter \"if [[ \\\"$`echo $VAR`\\\" = '$OLD' ]]; then export $VAR='$NEW'; fi\" $@; }; f\"";
      kdiff = "difftool --no-symlinks --dir-diff";
      fpush = "push --force-with-lease --force-if-includes";
      graph = "log --graph --oneline";
      sync = "! git add . && git commit -m 'sync' && git pull --rebase && git push";
      shash = "rev-parse --short=9";
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
}
