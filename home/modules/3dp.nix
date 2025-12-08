{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cura-appimage
    freecad-wayland
    openscad
    blender
    # cura
    orca-slicer


    (writeShellScriptBin "ender" ''
      HOST="http://192.168.178.71"
      CMD=$1
      PATH_ARG=$2

      if [ "$CMD" = "cp" ]; then
        FILENAME=$(basename "$PATH_ARG")
        echo "$FILENAME"
        curl -F "file=@$PATH_ARG" "$HOST/upload.cgi"
      elif [[ "$CMD" = "rm" && "$PATH_ARG" = "-a" ]]; then
        FILES=$(curl -s "$HOST/command.cgi?op=100&DIR=/")
        echo "$FILES" | tail -n +2 | while IFS=',' read -r dir name rest; do
          echo "DEL $name"
          curl -s "$HOST/upload.cgi?DEL=/$name"
          echo ""
        done
      elif [ "$CMD" = "rm" ]; then
        FILENAME=$(basename "$PATH_ARG")
        echo "DEL $FILENAME"
        curl "$HOST/upload.cgi?DEL=/$FILENAME"
        echo ""
      elif [ "$CMD" = "ls" ]; then
        FILES=$(curl -s "$HOST/command.cgi?op=100&DIR=/")
        echo "$FILES" | tail -n +2 | while IFS=',' read -r dir name rest; do
          echo "$name"
        done
      else
        PROG=$(basename "$0")
        echo "USAGE:"
        echo "$PROG cp <path>"
        echo "$PROG rm [-a]"
        echo "$PROG ls"
      fi
    '')
  ];

  xdg.mimeApps.defaultApplications = {
    "model/3mf" = [ "OrcaSlicer.desktop" ];
    "model/stl" = [ "OrcaSlicer.desktop" ];
  };

}
