{ pkgs, inputs, lib, config, ... }:

let
  opacity = 0.0; # we let niri handle this
  rivendell = pkgs.fetchurl {
    url = "https://cloud.jeschek.eu/s/6MJ6kZ3itQ5Ea73/download/rivendell.png";
    hash = "sha256-AE3wqoOKXyWsoeUFsVlYqTPDkqpAsQdk3k7qGAn0cmc=";
  };
in

{
  stylix = {
    enable = true;
    polarity = "dark"; # in case we generate based on image
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

    image = rivendell;

    fonts = {
      serif = {
        package = pkgs.nerd-fonts.liberation;
        name = "Liberation Serif";
      };

      sansSerif = {
        package = pkgs.nerd-fonts.liberation;
        name = "Liberation Sans";
      };

      monospace = {
        package = pkgs.nerd-fonts.caskaydia-cove;
        name = "CaskaydiaCove Nerd Font Mono";
      };

      emoji = {
        package = inputs.apple-emojis.packages.x86_64-linux.apple-emoji-linux;
        name = "AppleColorEmoji";
      };
    };

    opacity.applications = opacity;
    opacity.terminal = opacity;
  };

}
