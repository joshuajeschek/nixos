{ config, pkgs, ... }:

let
  shorthands = (import ./../../private/_email.nix).shorthands;
  generateEnvFiles = shorthands:
    builtins.listToAttrs (
      map (shorthand: {
        name = ".config/waybar-extra/" + shorthand + ".env";
        value = {
          text = "#!/usr/bin/env bash\nexport ADDRESS='" + shorthands.${shorthand} + "'\n";
        };
      }) (builtins.attrNames shorthands)
    );
in

{
  programs.waybar.enable = true;

  # accounts.email.accounts = builtins.trace (builtins.readFile debugAccounts) accounts;
  home.file = {
    ".config/waybar".source = ./config;
  } // (generateEnvFiles shorthands);
}
