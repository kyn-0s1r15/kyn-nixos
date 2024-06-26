{ config, lib, pkgs, inputs, ... }:
let
inherit (import ./settings.nix) UserName Theme;
in {

  imports = [
  ];

#  systemd.services.nix-daemon.environment = {
#    http_proxy = "http://saltmelon:iZ6!9&4DNA^CIA@369.444.777.777:8008/";
#  };

  
#OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO

  environment = {
    pathsToLink = [ "/share/zsh" ];
    systemPackages = with pkgs; [];
    # $ nix search <>
    sessionVariables = {
    };
  };

#OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO

  # USER
  users.users.kyn = {
    isNormalUser = true;
    description = "${UserName}";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {inherit inputs;};
    users = {
      "${UserName}" = import ./hyprland.nix;
    };
  };
  styling.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${Theme}.yaml";
  stylix.image = ~/Pictures/Wallpapers/wp12329545-nixos-wallpapers.png;  # Don't forget to apply wallpaper
  stylix.cursor.package = pkgs.bibata-cursors;
  stylix.cursor.name = "Bibata-Modern-Amber";

  stylix.fonts = {
#    monospace = {
#      package = (pkgs.nerdfonts.override {fonts = ["Hermit"];});
#      name = "Hurmit Nerd Font";
#    };
    monospace = {
      package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
      name = "JetBrainsMono Nerd Font Mono";
    };
    sansSerif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Sans";
    };
    serif = {
      package = pkgs.dejavu_fonts;
      name = "DejaVu Serif";
    };
  };

  stylix.fonts.sizes = {
    applications = 12;
    terminal = 15;
    desktop = 10;
    popups = 10;
  };

  stylix.opacity = {
    applications = 0.96;
    terminal = 0.69;
    desktop = 1.0;
    popups = 0.84;
  };



  stylix.polarity = "dark"; # "light" or "either"

#OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO

#  programs.mtr.enable = true;  # Some programs need SUID wrappers, can be configured further or are started in user sessions
#  programs.gnupg.agent = {
#    enable = true;
#    enableSSHSupport = true;
#  };
#  networking.proxy.default = "http://user:password@proxy:port/";
#  networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
#  Enable the OpenSSH daemon.
#  services.openssh.enable = true;
#  Open ports in the firewall.
#  networking.firewall.allowedTCPPorts = [ ... ];
#  networking.firewall.allowedUDPPorts = [ ... ];
#  Or disable the firewall altogether.
#  networking.firewall.enable = false;
#  boot.kernelPackages = pkgs.linuxPackages_latest;

#OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO

  # COMPOSITOR

  security.polkit.enable = true;

  nix.settings = {
#    experimental-features = [
#      "nix-command"
#      "flakes"
#    ];

    # binary caches
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
    substituters = [
      "https://cache.nixos.org"
      "https://nixpkgs-wayland.cachix.org"
      "https://hyprland.cachix.org"
    ];
  };

#OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO

  # HARDWARE
  hardware.opengl.enable = true;
  services.system76-scheduler.settings.cfsProfiles.enable = true;  # Efficient schedule management for CPU cycles
  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };

#OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO

#  services.logind.lidSwitchExternalPower = "ignore"; # Do nothing if AC on
  powerManagement.powertop.enable = true;
  services.thermald.enable = true; # (Only necessary on Intel CPUs)
  services.upower.enable = true; #upower
  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = false;
  };
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = false;
  services.printing.enable = true;
  services.dbus.enable = true;
  services.auto-cpufreq.enable = true;
  programs.zsh.enable = true;

#OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO

#Nvidia
#  services.xserver = {
#    videoDrivers = [ "nvidia" ];
   #  config = ''
   #    Section "Device"
   #        Identifier  "Intel Graphics"
   #        Driver      "intel"
   #       #Option      "AccelMethod"  "sna" # default
   #       #Option      "AccelMethod"  "uxa" # fallback
   #        Option      "TearFree"        "true"
   #        Option      "SwapbuffersWait" "true"
   #        BusID       "PCI:0:2:0"
   #       #Option      "DRI" "2"             # DRI3 is now default
   #    EndSection
   #
   #    Section "Device"
   #        Identifier "nvidia"
   #        Driver "nvidia"
   #        BusID "PCI:1:0:0"
   #        Option "AllowEmptyInitialConfiguration"
   #        Option         "TearFree" "true"
   #    EndSection
   #  '';
   # screenSection = ''
   #   Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
   #   Option         "AllowIndirectGLXProtocol" "off"
   #   Option         "TripleBuffer" "on"
   #   '';
   #  deviceSection = '' 
   #  Option "TearFree" "true"
   # '';
#  };
#  hardware = {
#  opengl.enable = true;
#  opengl.driSupport = true;
#  opengl.driSupport32Bit = true;
#   opengl = {
#      extraPackages = with pkgs; [
#        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        #vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
#        vaapiVdpau
#        libvdpau-va-gl
#        mesa.drivers
#      ];
#   };
#  nvidia.nvidiaSettings = true;
#  nvidia.powerManagement.enable = true;
#  nvidia.powerManagement.finegrained = true;
#  nvidia.forceFullCompositionPipeline = true;
  # nvidia-drm.modeset=1 is required for some wayland compositors, e.g. sway
#  nvidia.modesetting.enable = true;
#  nvidia.nvidiaPersistenced = true;
#  #nvidia.open = true;
  # Optionally, you may need to select the appropriate driver version for your specific GPU.
#  nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  #offload , Sync or reverseSync
#    nvidia.prime = {
    #reSync Mode
    # reverseSync.enable = true;
    #Sync Mode
     #sync.enable = true;
    #Offload Mode
#      offload = {
#      enable = true;
#      enableOffloadCmd = true;
#     };
    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
#    nvidiaBusId = "PCI:1:0:0";
    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
#    intelBusId = "PCI:0:2:0";
#  };
#  };
    #Testing stuff
   # nixpkgs.config.packageOverrides = pkgs: {
   #   vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
   # };  
  # Cuda?
  #services.xmr-stak.cudaSupport = true; 
  #Switch GPU
  #services.switcherooControl.enable = true;
  # Nvidia in Docker
#   virtualisation.docker = {
#    enable = true;
#    enableOnBoot= true;
#    enableNvidia = true;
#   }; 
#   systemd.enableUnifiedCgroupHierarchy = false;


#OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO

}
