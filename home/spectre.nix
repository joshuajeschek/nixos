{ pkgs, ... }:
{
  imports = [ ./base.nix ];

  home.packages = with pkgs; [
  inxi
  brightnessctl
  ];
}
