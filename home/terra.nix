{ pkgs, ... }:
{
  imports = [ ./base.nix ];

  home.packages = with pkgs; [
    (writeShellScriptBin "reboot-windows" ''
      curl http://192.168.178.37:8123/api/webhook/-f2JRca5toPYhQQcfMBmzKavR
      echo ""
      echo "Rebooting into Windows"
      reboot
    '')
    (writeShellScriptBin "reboot-linux" ''
      curl http://192.168.178.37:8123/api/webhook/-yJ5Zwfbkk0XnZVS_lcXuLDdq
      echo ""
      echo "Rebooting into Linux"
      reboot
    '')
  ];

  wayland.windowManager.hyprland.settings.workspace = [
    "1, monitor:DP-1, default:true"
    "2, monitor:DP-1, default:true"
    "3, monitor:DP-1, default:true"
    "4, monitor:DP-1, default:true"
    "5, monitor:DP-1, default:true"
    "6, monitor:HDMI-A-1, default:true"
    "7, monitor:HDMI-A-1, default:true"
    "8, monitor:HDMI-A-1, default:true"
    "9, monitor:HDMI-A-2, default:true"
    "6, vesktop"
    "9, stremio"
  ];
}
