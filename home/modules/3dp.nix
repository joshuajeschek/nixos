{ pkgs, ... }:

{
  home.packages = with pkgs; [
    cura-appimage
    freecad-wayland
    openscad
    blender
    orca-slicer
    # cura
  ];

  xdg.mimeApps.defaultApplications = {
    "model/3mf" = [ "cura.desktop" ];
  };

}
