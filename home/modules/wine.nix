
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # wineWowPackages.waylandFull
    wineWowPackages.staging
    winetricks
  ];
}
