{ lib, pkgs, config, ... }:
let
  mkIcon = name: url: sha256: {
    inherit name;
    icon = pkgs.fetchurl {
      inherit url sha256;
    };
  };

  icons = [
    (mkIcon "scribus"
      "https://gist.githubusercontent.com/ejpcmac/a74b762026c9bc4000be624c3d085517/raw/18edc497c5cb6fdeef1c8aede37a0ee68413f9d3/scribus-icon-centered.svg"
      "0hq3i7c2l50445an9glhhg47kj26y16svfajc6naqn307ph9vzc3")
    (mkIcon "ecosia"
      "https://www.ecosia.org/static/icons/favicon.ico"
      "Az6a/j4qSQntWeAXsmc6QpEZQyNDFNjaIK9J27dCwW8=")
    (mkIcon "home-manager"
      "https://avatars.githubusercontent.com/u/33221035"
      "lupUu19yxO6FdRAM/irWcs2C0O7exl266irX8MWlSvE=")
    (mkIcon "nixos"
      "https://nixos.org/favicon.svg"
      "UL/Eyk/e7Yrfz8uR9MZwB80a+S4HC9CjixpW8tpJMvY=")
  ];
in
{
  home.activation.installIcons = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${lib.concatMapStringsSep "\n" (iconData: ''
      echo "installing ${iconData.name} icon"
      for i in 16 24 48 64 96 128 256 512; do
        mkdir -p ${config.home.homeDirectory}/.local/share/icons/hicolor/''${i}x''${i}/apps
        ${pkgs.imagemagick}/bin/magick -background none ${iconData.icon}[0] -resize ''${i}x''${i} ${config.home.homeDirectory}/.local/share/icons/hicolor/''${i}x''${i}/apps/${iconData.name}.png
      done
    '') icons}
  '';
}
