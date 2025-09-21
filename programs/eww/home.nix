{ pkgs, ... }:

{
  home.packages = with pkgs; [
    eww
  ];
  home.file = {
    ".config/eww".source = ./config;
  };
}
