{ lib, pkgs, inputs, ... }:

let
  # m4b-tool = builtins.getFlake "github:sandreas/m4b-tool";
  # pyamlboot = builtins.getFlake "github:joshuajeschek/pyamlboot-flake";
in

{
  home.packages = with pkgs; [
    gcr
    gnumake
    vesktop
    # deadd-notification-center
    swaynotificationcenter
    gnupg
    signal-desktop
    gimp
    steam
    neofetch
    baobab
    texliveFull
    typst
    spotify
    inputs.zen-browser.packages.${pkgs.system}.default
    mutt-wizard
    pinentry-rofi
    stremio
    ddcutil
    ddcui
    libreoffice-still
    unzip
    gcc
    ripgrep
    pass
    isync
    libnotify
    python312
    python312Packages.pip
    python312Packages.virtualenv
    nodejs_22
    nodePackages_latest.typescript-language-server
    nodePackages_latest.vscode-json-languageserver
    #nodePackages_latest.svelte-language-server
    nodePackages_latest.prettier
    android-studio
    ghidra
    android-tools
    adbfs-rootless
    bento4
    # m4b-tool.packages.${builtins.currentSystem}.default
    vlc
    pamixer
    jq
    evince
    cheese
    sshfs
    helvum
    # pyamlboot.packages.${builtins.currentSystem}.default
    libusb1
    usbutils
    chromium
    appimage-run
    inkscape
    imagemagick
    qgis
    zotero
    eduvpn-client
    gdb
    # ladybird
    kdePackages.okular
    poppler_utils
    ffmpeg
    speedtest-cli
    ausweisapp
    postman
    gparted
    cemu
    exiftool
    zip
    tealdeer
    bat
    fx
  ];


}
