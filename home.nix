{ lib, config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "eryk";
  home.homeDirectory = "/home/eryk";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
  	 # Internet
     google-chrome discord

     # Theming
     materia-theme papirus-icon-theme tela-icon-theme
  ];

  dconf.enable = true;
  dconf.settings = {
    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };
  };
  
  nixpkgs.config.packageOverrides = pkgs: {
    google-chrome = pkgs.google-chrome.override { commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland"; };
  };
  
}
