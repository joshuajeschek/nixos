{ pkgs ? import <nixpkgs> {} }:

let
  mkScript = name: text: pkgs.writeShellScriptBin name text;

  scriptData = {
    rebuild = ''
      [ -n "$NIXOS_ROOT" ] && cd $NIXOS_ROOT
      sudo nixos-rebuild --flake path:.#$HOST "$@"
    '';
  };
  scripts = map (name: mkScript name scriptData.${name}) (builtins.attrNames scriptData);
  scriptNames = map (s: s.name) scriptData;
in

pkgs.mkShell {
  shellHook = ''
    NIXOS_ROOT="${builtins.toString ./.}"
    export NIXOS_ROOT
    echo "= Available commands: ${builtins.toString (builtins.attrNames scriptData)}"
  '';
  buildInputs = scripts;
}
