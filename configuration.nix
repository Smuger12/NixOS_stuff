{ lib, config, pkgs, ... }:

{
  imports =
    [ 
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # home-manager
      <home-manager/nixos>
    ];

  #boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.firmware = with pkgs; [
  	firmwareLinuxNonfree
  	alsa-firmware
  ];
  
  hardware.cpu.intel.updateMicrocode = true;

  boot.supportedFilesystems = [ "ext4" "fat8" "fat16" "fat32" "exfat" "ntfs" ];
  
  # Use the systemd-boot bootloader.
  boot.loader = {
  	systemd-boot.enable = true;
  	efi.canTouchEfiVariables = true;
  	systemd-boot.consoleMode = "1";
  };

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";
  
  # Network stuff
  networking = { 
    hostName = "Skynet"; 
    networkmanager.enable = true;
    
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp1s0.useDHCP = true;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
    
  console = { 
    #packages = with pkgs; [ terminus_font ];
    #font = "latarcyrheb-sun32";
    useXkbConfig = true;
    earlySetup = true;
  };

  environment.variables = {
    EDITOR = "micro";
  };
  
  # Enable the X11 windowing system.
  services.xserver = {
  
  	enable = true;
  	
  	# Enable the Desktop Environment.
  	desktopManager = {
  		xterm.enable = lib.mkForce false;
  	    gnome.enable = true;
  	    gnome.sessionPath = with pkgs.gnome; [ mutter gnome-shell nautilus ];
        gnome.extraGSettingsOverridePackages = with pkgs; [ gnome.mutter gnome.gnome-shell gnome.nautilus gsettings-desktop-schemas ];
    };
    
  	displayManager = {
  		gdm.enable = true;
  		gdm.wayland = true;
  	};

  	libinput = {
  		enable = true;
  		touchpad.naturalScrolling = true;
  		#touchpad.accelProfile = "flat";
  		#touchpad.accelSpeed = "0";
  	};
  
 	# Configure keymap in X11
  	layout = "gb";
  	xkbVariant = "pl";

  	videoDrivers = [ "modesetting" ];
  	useGlamor = true;
  };

  services.auto-cpufreq.enable = true;
  
  # Enable codecs.
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      intel-compute-runtime
      intel-ocl
    ];
  };

  # Enable bluetooth.
  hardware.bluetooth = { 
  	enable = true;
  	package = pkgs.bluezFull;
  };
  
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Printing
  services.printing.enable = lib.mkForce false;

  # Define a user account. 
  users.users.eryk = {
     home = "/home/eryk";
     isNormalUser = true;
     description = "Eryk";
     extraGroups = [ "wheel" "networkmanager" ]; 
  };

  home-manager = { 
     useGlobalPkgs = true;
     useUserPackages = true;
  };
  
  nix.autoOptimiseStore = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nixpkgs.config.allowUnfree = true;
  
  # List packages installed in system profile. 
  environment.systemPackages = with pkgs; [
     # Terminal utilities
     micro xclip wget git neofetch htop intel-gpu-tools dconf2nix
     
     # Gnome stuff
     gnome.gnome-tweak-tool gnome.dconf-editor
  ];
  
  programs.dconf.enable = true;

  qt5.platformTheme = "gnome";
  
  # Debloat gnome ;)
  environment.gnome.excludePackages = with pkgs; [
     gnome.geary
     epiphany
     gnome.gnome-photos
     gnome.gnome-calendar
     gnome.gnome-characters
     gnome.gnome-contacts
     gnome.gnome-logs
     gnome.gnome-maps
     simple-scan
     gnome.gnome-font-viewer
     gnome.yelp
     gnome.gnome-clocks
     gnome-connections
     gnome.seahorse
     gnome-tour
     gnome.cheese
  ];

  # Enable the OpenSSH daemon.
  #services.openssh.enable = true;
  programs.ssh.askPassword = lib.mkForce " ";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It???s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?  
}
