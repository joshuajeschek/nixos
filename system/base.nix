# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

let
  # Import network mappings from private repo
  networkMappings = import "${inputs.private}/_networks.nix";

  # Generate sops secrets for WPA2 networks
  wpa2Secrets = builtins.mapAttrs (sopsKey: ssid: {
    path = "/var/lib/iwd/${ssid}.psk";
  }) networkMappings.wpa2Networks;
in

{

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config = {
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
      "spotify"
      "android-studio-stable"
      "copilot.vim"
      "stremio-shell"
      "stremio-server"
      "postman"
      "castlabs-electron" # for tidal
      "vscode"
    ];
    permittedInsecurePackages = [
      "qtwebengine-5.15.19"
    ];
  };

  hardware.i2c.enable = true;
  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Experimental = true;
      };
    };
  };

  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1b8e", ATTRS{idProduct}=="c003", OWNER="main", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="1d6b", ATTRS{idProduct}=="1014", OWNER="main", MODE="0666"
  '';

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = false;
      setSocketVariable = false;
    };
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    device = "nodev";
    efiSupport = true;
  };

  sops = {
    defaultSopsFile = "${inputs.private}/secrets.yaml";
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/main/.config/sops/age/keys.txt";
  };

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  sops.secrets = {
    "networks/eduroam" = { path = "/var/lib/iwd/eduroam.8021x"; };
    "networks/eduroam-cert" = { path = "/var/lib/iwd/eduroam.pem"; };
  } // (lib.mapAttrs' (k: v: {
    name = "networks/${k}";
    value = v;
  }) wpa2Secrets);

  # Set your time zone.
  time = {
    timeZone = "Europe/Berlin";
    hardwareClockInLocalTime = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    useXkbConfig = true;
  };

  security.rtkit.enable = true;
  # services.gnome3.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # keys are configured using home manager
  security.pam.services.unlock_pgp.gnupg.enable = true;

  # security.pam.services.gnome_keyring.text = ''
  #   auth     optional    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so
  #   session  optional    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start
  #
  #   password  optional    ${pkgs.gnome-keyring}/lib/security/pam_gnome_keyring.so
  # '';

  # services.displayManager.sddm = {
  #   enable = true;
  #   wayland.enable = true;
  #   theme = "chili";
  # };
  # services.displayManager.ly = {
  #   enable = true;
  # };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      # (nerdfonts.override { fonts = [ "CascadiaCode" ]; })
      nerd-fonts.caskaydia-cove
      ibm-plex
    ];
    fontconfig = {
      defaultFonts = {
        serif = [  "Liberation Serif" "Vazirmatn" ];
        sansSerif = [ "Ubuntu" "Vazirmatn" ];
        monospace = [ "CaskaydiaCove Nerd Font Mono" ];
      };
    };
  };


  # Configure keymap in X11
  services.xserver.xkb.layout = "de";
  services.xserver.xkb.variant = "nodeadkeys";
  services.xserver.xkb.options = "caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  programs.hyprland.enable = true;
  programs.niri.enable = true;
  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.main = {
    uid = 1000;
    initialPassword = "pw123";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "i2c" ];
    shell = pkgs.zsh;
  };


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    firefox
    neovim
    wget
    pavucontrol
    tree
    git
    # hyprland
    xdg-utils
    grim
    slurp
    pipewire
    wireplumber
    zathura
  ];

  services.davfs2.enable = true;
  services.flatpak.enable = true;

  xdg.portal = {
    enable = true;
    # xdgOpenUsePortal = true;
    config = {
      common.default = ["gtk"];
      hyprland.default = ["hyprland" "gtk"];
      # niri.default = ["gnome"];
      niri = {
        default = ["gnome" "gtk"];
        "org.freedesktop.impl.portal.Access" = ["gtk"];
        "org.freedesktop.impl.portal.Notification" = ["gtk"];
        "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
      };
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];
  };

  # this is a workaround
  systemd.user.services.xdg-desktop-portal = {
    environment = {
      NIX_XDG_DESKTOP_PORTAL_DIR = "/run/current-system/sw/share/xdg-desktop-portal/portals";
    };
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.fail2ban.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      AllowUsers = [ "main" ];
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
  # not for networkmanager (but for wpa_supplicant)
  #  networking.wireless.networks.eduroam = {
  #   auth = ''
  #     key_mgmt=WPA-EAP
  #     eap=PWD
  #     phase2="auth=MSCHAPV2"
  #     identity="go49hag@eduroam.mwn.de"
  #     password="M6s%xq*z$QeVC!qQ@NN*"
  #   '';
  # };
}
