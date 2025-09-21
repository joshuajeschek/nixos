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
}
