{ config, pkgs, lib, ... }:

let
  getSimpleConfigs = dir:
    builtins.map (file: dir + ("/" + file))
      (builtins.filter (file: builtins.match "^[^_].+\\.nix$" file != null)
        (builtins.attrNames (builtins.readDir dir)));

  getDirectoryConfigs = dir:
    builtins.map (subdir: dir + ("/" + subdir) + "/home.nix")
      (builtins.filter (subdir: builtins.pathExists (dir + ("/" + subdir) + "/home.nix"))
        (builtins.attrNames (builtins.readDir dir)));

  imports = [ ./pkgs.nix ]
    ++ getSimpleConfigs ./programs
    ++ getDirectoryConfigs ./programs
    ++ getSimpleConfigs ../private
    ++ getDirectoryConfigs ../private;

  importsAsString = builtins.concatStringsSep "\n  " (builtins.map builtins.toString imports);
in

{
  # imports = builtins.trace "Imports:\n  ${importsAsString}" imports;
  imports = imports;
  gtk.theme = "Adwaita:dark";
  services.clipman.enable = true;
  services.gnome-keyring.enable = true;
  programs.ssh.enable = true;
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "main";
  home.homeDirectory = "/home/main";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.file = {
    ".local/share/fonts".source = ./fonts;
    ".pam-gnupg".text = ''
      EFB0BA9CA5B641E9E08666F5BFC91481AAF224EF
    '';
    ".gnupg/gpg-agent.conf".text = ''
      allow-preset-passphrase
      max-cache-ttl 86400
    '';
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
