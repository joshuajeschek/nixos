{ pkgs ? import <nixpkgs> {} }:

let
  mkScript = name: text: pkgs.writeShellScriptBin name text;

  scriptData = {
    rebuild = ''
      [ -n "$NIXOS_ROOT" ] && cd $NIXOS_ROOT
      sudo nixos-rebuild --flake path:.#$HOST "$@"
    '';
    update = ''
      set -e
      cd "$NIXOS_ROOT"
      nix flake update
    '';
    generations = ''
      profile="/nix/var/nix/profiles/system"

      sudo nix-env --list-generations --profile "$profile" | while read -r line; do
        gen=$(echo "$line" | awk '{print $1}')
        if [[ "$gen" =~ ^[0-9]+$ ]]; then
          gen_path="$profile-$gen-link"

          # Get NixOS version
          if [[ -f "$gen_path/nixos-version" ]]; then
            nixos_version=$(cat "$gen_path/nixos-version")
          else
            nixos_version="unknown"
          fi

          echo "$line | NixOS: $nixos_version"
        else
          echo "$line"
        fi
      done
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
