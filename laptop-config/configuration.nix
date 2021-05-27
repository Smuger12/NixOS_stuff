{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  hardware.firmware = with pkgs; [
  	firmwareLinuxNonfree
  	alsa-firmware
  ];

  hardware.cpu.intel.updateMicrocode = true;

  boot.supportedFilesystems = [ 
  "ext4" "exfat" "fat8" "fat16" "fat32" "ntfs" 
  ];
  
  # Use the systemd-boot bootloader.
  boot.loader = {
  	systemd-boot.enable = true;
  	efi.canTouchEfiVariables = true;
  	systemd-boot.consoleMode = "auto";
  };

  networking.hostName = "Skynet"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  
  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp1s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
     font = "Lat2-Terminus16";
     useXkbConfig = true;
     #keyMap = "pl";
   };

  # Enable the X11 windowing system.
  services.xserver = {
  
  	enable = true;
  	
  	# Enable the KDE Plasma Desktop Environment.
  	desktopManager = { 
  	    plasma5.enable = true;
  	};
  	displayManager = {
  		sddm.enable = true;
  		sddm.enableHidpi = true;
  		autoLogin.enable = true;
  		autoLogin.user = "eryk";
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

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  hardware.opengl.driSupport32Bit = true;
  
  hardware.bluetooth = { 
  	enable = true;
  	package = pkgs.bluezFull;
  };
  
  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.eryk = {
     home = "/home/eryk";
     isNormalUser = true;
     description = "Eryk";
     extraGroups = [ "wheel" "networkmanager" ]; 
  };

  nixpkgs.config.allowUnfree = true;

  nix.autoOptimiseStore = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  
  # List packages installed in system profile. 
  environment.systemPackages = with pkgs; [
     # Terminal utilities
     micro xclip wget git neofetch htop
     # Internet
     google-chrome discord
     # KDE stuff
     partition-manager kwrited sddm-kcm
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}

