{ pkgs, config, ... }:

let
  make-nix-shell = (pkgs.writeShellScriptBin "make-nix-shell" ''
    test -f shell.nix && echo 'Not overwriting existing shell.nix.' && exit 1
    cat > shell.nix << 'EOF'
    { pkgs ? import <nixpkgs> {} }:

    pkgs.mkShell {
      # buildInputs = with pkgs; [
      # ];

      # shellHook = '''
      # ''';
    }
    EOF
    echo 'Generated empty shell.nix.'
  '');
in

{
  home.packages = with pkgs; [
    vscode
    wakatime-cli
    gnumake
    texliveFull
    typst
    gcc
    gdb
    python312
    python312Packages.pip
    python312Packages.virtualenv
    nodejs_22
    nodePackages_latest.prettier
    mdformat
    # could be extracted to project shell.
    android-studio
    ghidra
    android-tools
    adbfs-rootless
    bento4
    platformio
    # custom commands
    make-nix-shell
  ];

  sops.secrets.".wakatime.cfg" = { path = "${config.home.homeDirectory}/.wakatime.cfg"; };
}
