{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gnumake
    texliveFull
    typst
    gcc
    gdb
    python312
    python312Packages.pip
    python312Packages.virtualenv
    nodejs_22
    nodePackages_latest.typescript-language-server
    nodePackages_latest.vscode-json-languageserver
    nodePackages_latest.prettier
    # could be extracted to project shell.
    android-studio
    ghidra
    android-tools
    adbfs-rootless
    bento4
  ];
}
