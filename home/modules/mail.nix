{ config, lib, pkgs, ... }:

let

  mailPath = ".local/share/mail";

  defaults = {
    mbsync.enable = true;
    mbsync.create = "both";
    thunderbird.enable = true;
  };

  aercConfig = address: {
    aerc = {
      enable = true;
      extraAccounts = {
        "check-mail-cmd" = "mbsync ${address}";
      };
    };
  };

  accounts = builtins.listToAttrs (builtins.map
    (account: {
      name = account.address;
      value = defaults // (aercConfig account.address) // account; })
    (import ../../private/_email.nix).accounts);
  debugAccounts = pkgs.runCommand "pretty-json" {} ''
    echo '${builtins.toJSON accounts}' | ${pkgs.jq}/bin/jq '.' > $out
  '';

  nextcloud = (import ../../private/_contacts.nix).nextcloud // {
    local = {
      type = "filesystem";
      fileExt = ".vcf";
      path = "${config.home.homeDirectory}/.contacts/nextcloud";
    };
    vdirsyncer.enable = true;
    khard.enable = true;
    # khard.defaultCollection = "Contacts";
  };
  debugNextcloud = pkgs.runCommand "pretty-json" {} ''
    echo '${builtins.toJSON nextcloud}' | ${pkgs.jq}/bin/jq '.' > $out
  '';

  mailSecrets = builtins.listToAttrs (map (address: {
    name = "mail/${address}";
    value = { };
  }) (builtins.attrNames accounts));

in

{
  # EMAIL
  accounts.email.maildirBasePath = mailPath;
  programs.mbsync.enable = true;
  services.mbsync.enable = true;
  # accounts.email.accounts = builtins.trace (builtins.readFile debugAccounts) accounts;
  accounts.email.accounts = accounts;

  # CONTACTS
  programs.vdirsyncer.enable = true;
  services.vdirsyncer.enable = true;
  programs.khard.enable = true;
  # accounts.contact.accounts.nextcloud = builtins.trace (builtins.readFile debugNextcloud) nextcloud;
  accounts.contact.accounts.nextcloud = nextcloud;

  # EMAIL AND NEXTCLOUD PASSWORDS
  sops.secrets = mailSecrets // (import ../../private/_contacts.nix).nextcloudSops;

  home.packages = with pkgs; [
    pandoc
    outils
  ];

  programs.aerc = {
    enable = true;
    extraConfig = {
      general.unsafe-accounts-conf = true;
      compose = {
        editor = "nvim";
        address-book-cmd = "khard email --remove-first-line --parsable %s";
      };
      filters = {
        "text/plain" = "colorize";
        "text/html" = "pandoc -f html -t plain";
        "text/calendar" = "calendar";
        # "application/vnd.openxmlformats-officedocument.wordprocessingml.document" = "xdg-open $AERC_FILENAME";
      };
      openers = {
        "application/pdf" = "zathura";
      };
      ui = {
        threading-enabled = true;
        show-thread-context = true;
        thread-prefix-tip = "";
        thread-prefix-indent = "";
        thread-prefix-stem = "│";
        thread-prefix-limb = "─";
        thread-prefix-folded = "+";
        thread-prefix-unfolded = "";
        thread-prefix-first-child = "┬";
        thread-prefix-has-siblings = "├";
        thread-prefix-orphan = "┌";
        thread-prefix-dummy = "┬";
        thread-prefix-lone = " ";
        thread-prefix-last-sibling = "╰";
      };
      hooks = {
        mail-received = "notify-send \"[$AERC_ACCOUNT/$AERC_FOLDER] $AERC_FROM_NAME\" \"$AERC_SUBJECT\"";
      };
    };
    # currently prevents defaults :/
    # extraBinds = {
    #   messages = {
    #     "t" = ":read <Enter>:move Papierkorb<Enter>";
    #   };
    # };
  };

  programs.thunderbird = {
    enable = true;
    profiles.default.isDefault = true;
  };
}
