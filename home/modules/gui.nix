{ pkgs, inputs, config, lib, ... }:
{
  home.packages = with pkgs; [
    vesktop
    signal-desktop
    gimp
    steam
    baobab
    spotify
    tidal-hifi
    inputs.zen-browser.packages.${pkgs.system}.default
    # stremio
    libreoffice-still
    vlc
    evince
    cheese
    helvum
    chromium
    inkscape
    qgis
    zotero
    eduvpn-client
    kdePackages.okular
    ausweisapp
    postman
    gparted
    cemu
    gnucash
    anki-bin
    obs-studio
    pdfpc
    darktable
    imv
  ];

  xdg = {
    mimeApps.defaultApplications = {
      "text/html" = [ "zen.desktop" ];
      "x-scheme-handler/http" = [ "zen.desktop" ];
      "x-scheme-handler/https" = [ "zen.desktop" ];
      "x-scheme-handler/about" = [ "zen.desktop" ];
      "x-scheme-handler/unknown" = [ "zen.desktop" ];
      "image/*" = [ "imv.desktop" ];
      "application/pdf" = [ "org.pwmt.zathura.desktop" ];
    };
    desktopEntries = {
      imv = {
        name = "imv";
        genericName = "Image Viewer";
        exec = "imv %U";
        terminal = false;
        # categories = [ "Network" "WebBrowser" ];
        mimeType = [ "image/jpeg" "image/png" "image/jpg" ];
      };
    };
  };

# ZATHURA
  programs.zathura =
    # from https://github.com/nix-community/stylix/blob/6850ad2e9f3f7ff6116e9e6fb73a9cca2d9b1a35/modules/zathura/hm.nix
    let
      getColorCh = colorName: channel: config.lib.stylix.colors."${colorName}-rgb-${channel}";
      rgb =
        color:
        ''rgb(${getColorCh color "r"}, ${getColorCh color "g"}, ${getColorCh color "b"})'';
      rgba =
        color: alpha:
        ''rgba(${getColorCh color "r"}, ${getColorCh color "g"}, ${getColorCh color "b"}, ${toString alpha})'';
    in
    {
    enable = true;
    options = {
      font                  = "CaskaydiaCove Nerd Font Mono 12";
      selection-notification= true;
      selection-clipboard   = "clipboard";
      guioptions            = "sv";
      scroll-page-aware     = true;
      statusbar-home-tilde  = true;
      recolor               = true;
      recolor-keephue       = true;
      adjust-open           = "width";
      statusbar-h-padding   = 10;
      statusbar-v-padding   = 10;
      recolor-lightcolor = lib.mkForce (rgba "base00" 0);
      recolor-darkcolor  = lib.mkForce (rgb "base06");
    };
    mappings = {
      "1" = "set 'recolor-darkcolor \"#ffffff\"'";
      "2" = "set 'recolor-lightcolor \"#000000\"'";
      "4" = "set 'recolor-darkcolor \"${rgb "base06"}\"'";
      "5" = "set 'recolor-lightcolor \"${rgba "base00" 0}\"'";
      "<F1>" = "feedkeys '12'";
      "<F2>" = "feedkeys '45'";
    };
  };
}
