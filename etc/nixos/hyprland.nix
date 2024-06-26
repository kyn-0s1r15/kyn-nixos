{ self, config, pkgs, lib, inputs, ... }:
let
inherit (import ./settings.nix) StateVersion UserName GitUserName GitEmail Theme Editor Terminal Browser MediaPlayer Notes IDE FileManager Filer YaziFlavor RofiTheme NixDir CloudDir WallpaperDir Wallpaper;
  MyAliases = {
    checkpoint = "sudo cp -r ${NixDir} ~/GoogleDrive/nix${NixDir}$(date +\%Y-\%m-\%d_\%H-\%M)/";
    nset = "sudo ${Editor} ${NixDir}/settings.nix";
    cset = "cat ${NixDir}/settings.nix";
    nos = "sudo ${Editor} ${NixDir}/0s1r15.nix";
    cos = "cat ${NixDir}/0s1r15.nix";
    nhypr = "sudo ${Editor} ${NixDir}/hyprland.nix";
    chypr = "cat ${NixDir}/hyprland.nix";
    nflake = "sudo ${Editor} ${NixDir}/flake.nix";
    cflake = "cat ${NixDir}/flake.nix";
      switch = "sudo nixos-rebuild switch --flake ${NixDir}/#nixos --impure";
      clean = "sudo nix-collect-garbage -d";
      cleanold = "sudo nix-collect-garbage --delete-old";
        gitdir = "cd /";
        gitit = "sudo mkdir ./.git";
        gitown = "sudo chown ${UserName}:users ./.git";
        # git init
        gitremote = "git remote add nixos-0s1r15 git@github.com:kyn-0s1r15/nixos-0s1r15.git";
        gitadd = "git add ${WallpaperDir} ${NixDir}/.rice/ ${NixDir}/configuration.nix ${NixDir}/flake.nix ${NixDir}/hyprland.nix ${NixDir}/settings.nix ${NixDir}/0s1r15.nix";
        # git commit -m "message"
        gitpush = "git push -f nixos-0s1r15 main";
        gitpull = "git pull nixos-0s1r15 main";
        gitrm = "sudo rm -rf .git";
        gdrive = "mkdir $CloudDir} then sudo chown ${UserName}:users ${CloudDir} then ${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse -browser ${Browser} ~/GoogleDrive";
        ai = "${NixDir}/.rice/pacli/pacli.sh";
        fl = "${NixDir}/.rice/scripts/file_navigator.sh";
};

in
{
  imports = [
#  inputs.nix-colors.homeManagerModules.default
#  inputs.hyprland.homeManagerModules.default
#  inputs.hyprland.nixosModules.default
  ];
#  nixpkgs.overlays = [ #Supposed to override nixpkgs version with flake v>
#    (final: prev:
#      inputs.yazi.overlays.default
#      inputs.hyprland.overlays.default
#      inputs.nixpkgs-wayland.overlays.default
#      inputs.nix-colors.overlays.default
#      inputs.home-manager.overlays.default
#    )  ];
#  colorScheme = inputs.nix-colors.colorSchemes.${Theme};
  stylix.targets.firefox.enable = false;
  stylix.targets.waybar.enable = true;

  home.username = "${UserName}";
  home.homeDirectory = "/home/${UserName}";
  home.stateVersion = "${StateVersion}";
  home.packages = with pkgs; [ 
                                 /* APPLICATIONS */ dune3d gimp vlc firefox-wayland obsidian discord vscode 
                                 /* ISSUES */ google-drive-ocamlfuse gcalcli # gnome.nautilus
                                 /* INTEREST */ neofetch lz4
                                 /* HYPRLAND */ brightnessctl mpvpaper playerctl rofi-bluetooth
                                 /* YAZI */ ffmpegthumbnailer jq unrar zoxide poppler wl-clipboard fd ripgrep
                                 /* FONTS & ICONS */ nerdfonts font-awesome material-design-icons
                             ];
  home.file.".p10k.zsh".source = "${NixDir}/.rice/.p10k.zsh";
  home.file.".p10k.zsh".executable = true;
  home.sessionVariables.NIXOS_OZONE_WL="1";
  home.sessionVariables.POLKIT_AUTH_AGENT="${pkgs.polkit}/libexec/polkit-authenitaction-agent-1";
  home.sessionVariables._JAVA_AWT_WM_NONPARENTING="1";
  home.sessionVariables.hyprland_USE_PORTAL="1";
  home.sessionVariables.NIXOS_XDG_OPEN_USE_PORTAL="1";
  home.sessionVariables.XDG_CURRENT_DESKTOP="hyprland";
  home.sessionVariables.XDG_SESSION_TYPE="wayland";
  home.sessionVariables.XDG_SESSION_DESKTOP="hyprland";

  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.git.userName = "${GitUserName}";
  programs.git.userEmail = "${GitEmail}";
  programs.git.extraConfig.init.defaultBranch = "main";
  programs.git.extraConfig.safe.directory = "/";
  
  services.mako.enable = true;
  services.gammastep.enable = true;
  services.gammastep.provider = "manual";
  services.gammastep.latitude = -33.984422;
  services.gammastep.longitude = 25.667654;
  services.gammastep.temperature.night = 1900;

  programs.zsh.enable = true;
  programs.zsh.zplug.enable = true;
  programs.zsh.zplug = {
                    plugins = [ 
                                   { name = "zsh-users/zsh-autosuggestions"; } 
                                   { name = "zsh-users/zsh-syntax-highlighting"; } 
                                   { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } 
                               ];
                        };
  programs.zsh.oh-my-zsh.enable = true;
  programs.zsh.oh-my-zsh.plugins = [ "git" ];
#  programs.zsh.oh-my-zsh.theme = "romkatv/powerlevel10k";
  /* ALIASES */ programs.zsh.shellAliases = MyAliases;
  programs.zsh.history.size = 10000;
  programs.zsh.history.path = "${config.xdg.dataHome}/zsh/history";
  programs.zsh.initExtra = '' [[ ! -f ${NixDir}/.rice/.p10k.zsh ]] || source ${NixDir}/.rice/.p10k.zsh '';
  programs.zsh.autosuggestion.enable = true;
  programs.zsh.syntaxHighlighting.enable = true; 
  programs.starship.enable = true; 
  programs.starship.enableZshIntegration = true;
  programs.fzf.enable = true; 
  programs.fzf.enableZshIntegration = true;
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = false;
  programs.neovim.plugins = [
                              pkgs.vimPlugins.nvim-tree-lua {
                                                              plugin = pkgs.vimPlugins.vim-startify;
                                                              config = "let g:startify_change_to_vcs_root = 0";
                                                            }
                            ];
  programs.kitty.enable = true;
  programs.kitty.font.package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
  programs.kitty.font.name = "JetBrainsMono Nerd Font Mono";
#  programs.kitty.theme = "theme";
  programs.kitty.extraConfig = "linux_display_server wayland";
  programs.kitty.keybindings = { 
                                 "ctrl+c+alt+k>enter" = "new_window_with_cwd";
                                 "ctrl+c+alt+k>n" = "new_os_window_with_cwd";
                                 "ctrl+c+alt+k>t" = "new_tab_with_cwd";
                               };
  programs.rofi.package = pkgs.rofi-wayland;
  programs.rofi.enable = true;
#  programs.rofi.plugins = [pkgs.rofi-emoji];
  programs.rofi.configPath = ".config/rofi/config.rasi";
  programs.rofi.theme = "${RofiTheme}"; 

  programs.yazi.enable = true;
  programs.yazi.enableZshIntegration = true;
  programs.yazi.settings.theme.flavor.use = "${YaziFlavor}"; # https://yazi-rs.github.io/docs/flavors/overview/
  programs.yazi.package = pkgs.yazi;
#  programs.yazi.initLua = "~/init.lua";
#  programs.yazi.keymap = {  https://yazi-rs.github.io/docs/configuration/keymap/  };
# programs.yazi.plugin = { :3 };
  programs.yazi.settings.log.enabled = true;
  programs.yazi.settings.manager.show_hidden = true;
  programs.yazi.settings.manager.sort_by = "alphabetical";
  programs.yazi.settings.manager.sort_dir_first = true;
  programs.yazi.settings.manager.sort_reverse = false;
  programs.yazi.settings.manager.linemode = "size";
  programs.yazi.settings.manager.show_symlink = true;
#    yazi.settings.opener.edit = [ { run = 'sudo ${Editor} "$@"', block = true }; ];
#    yazi.settings.opener.play = [ { run = '${MediaPlayer} "$@"', orphan = true, for = "unix" } ];
#    yazi.settings.opener.open = [ { run = 'xdg-open "$@"', desc = "Open" }; ];
#    yazi.settings.open.rules = [ { mime = "text/", use = "edit" };
#	                          { mime = "video/", use = "play" };
#	                          { mime = "image/heic", use = "play" };
#	                          { mime = "image/gif", use = "play" };
#	                          { mime = "music/", use = "play" };
#	                          { mime = "image/", use = "open" };
#                       	  # { mime = "application/json", use = "edit" };
#	                          { name = "*.json", use = "edit" };
#	                          # Multiple openers for a single rule ["" ""]
#	                          { name = "*.html", use = "edit" }; ];
#  programs.yazi.settings.filetype.rules = [ { fg = "#7AD9E5"; mime = "image/'*'"; }
#                                            { fg = "#F3D398"; mime = "video/'*'"; }
#                                            { fg = "#F3D398"; mime = "audio/'*'"; }
#                                            { fg = "#CD9EFC"; mime = "application/x-bzip"; }
#                                          ];
#OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO

  wayland.windowManager.hyprland.enable = true;
  # Managed by flake overlay of nixpkgs version
  wayland.windowManager.hyprland.package = pkgs.hyprland; 
#  wayland.windowManager.hyprland.package = inputs.hyprland.homeManagerModules.default;
#  wayland.windowManager.hyprland.package = inputs.hyprland.nixosModules.default;
  wayland.windowManager.hyprland.systemd.enable = true;
  # exec-once dbus-update-activation-environment --systemd --all
  wayland.windowManager.hyprland.systemd.variables = [" --all"];
  wayland.windowManager.hyprland.settings.exec-once = [
        ''${pkgs.waybar}/bin/waybar''
        ''${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse /GoogleDrive''
        ''${pkgs.mako}/bin/mako''
        ''${pkgs.mpvpaper}/bin/mpvpaper -o "input-ipc-server=/tmp/mpv-socket --loop-playlist=inf" '*' ${WallpaperDir}/${Wallpaper}''
          ''touch ${NixDir}/.rice/scripts/waybar-network.sh''
          ''chmod +x ${NixDir}/.rice/scripts/waybar-network.sh''
          ''touch ${NixDir}/.rice/scripts/waybar-calendar.sh''
          ''chmod +x ${NixDir}/.rice/scripts/waybar-calendar.sh''
          ''touch ${NixDir}/.rice/scripts/waybar-rofi-bluetooth-toggle.sh''
          ''chmod +x ${NixDir}/.rice/scripts/waybar-bluetooth-toggle.sh''
          ''touch ${NixDir}/.rice/scripts/swww_randomize.sh''
          ''chmod +x ${NixDir}/.rice/scripts/swww_randomize.sh''
          ''touch ${NixDir}/.rice/scripts/file_navigator.sh''
          ''chmod +x ${NixDir}/.rice/scripts/file_navigator.sh''
  ];
  wayland.windowManager.hyprland.settings.input.kb_layout = "za";
  wayland.windowManager.hyprland.settings.input.kb_model = "mac";
  wayland.windowManager.hyprland.settings.input.kb_options = "";
  wayland.windowManager.hyprland.settings.input.kb_rules = "";
  wayland.windowManager.hyprland.settings.input.follow_mouse = "1";
  wayland.windowManager.hyprland.settings.input.touchpad.natural_scroll = true;
  wayland.windowManager.hyprland.settings.input.sensitivity = "0"; # -1.0 - 1.0, 0 means no modification.
  wayland.windowManager.hyprland.settings.general.gaps_in = "4";
  wayland.windowManager.hyprland.settings.general.gaps_out = "4";
  wayland.windowManager.hyprland.settings.general.border_size = "1";
#  wayland.windowManager.hyprland.settings.general."col.active_border" = lib.mkForce "rgb(${config.stylix.base16Scheme.base0D}) rgb(${config.stylix.base16Scheme.base0E}) 45deg";
#  wayland.windowManager.hyprland.settings.general."col.inactive_border" = lib.mkForce "rgb(${config.stylix.base16Scheme.base0A})";
  wayland.windowManager.hyprland.settings.general.layout = "dwindle";
  wayland.windowManager.hyprland.settings.general.allow_tearing = false;
  wayland.windowManager.hyprland.settings.decoration.rounding = "4";
  wayland.windowManager.hyprland.settings.decoration.blur.enabled = false;
#  wayland.windowManager.hyprland.settings.decoration.blur.size = "3";
#  wayland.windowManager.hyprland.settings.decoration.blur.passes = "1";
  wayland.windowManager.hyprland.settings.decoration.drop_shadow = false;
#  wayland.windowManager.hyprland.settings.decoration.shadow_range = "4";
#  wayland.windowManager.hyprland.settings.decoration.shadow_render_power = "3";
#  wayland.windowManager.hyprland.settings.decoration."col.shadow" = lib.mkForce "rgb(${config.stylix.base16Scheme.base0E})";
#  wayland.windowManager.hyprland.settings.decoration.active_opacity = "0.96";
#  wayland.windowManager.hyprland.settings.decoration.inactive_opacity = "0.84";
  wayland.windowManager.hyprland.settings.animations.enabled = false;
  wayland.windowManager.hyprland.settings.dwindle.pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
  wayland.windowManager.hyprland.settings.dwindle.preserve_split = true; # you probably want this
  wayland.windowManager.hyprland.settings.master.new_is_master = true;
  wayland.windowManager.hyprland.settings.gestures.workspace_swipe = true;
  wayland.windowManager.hyprland.settings.misc.disable_autoreload = true;
#  wayland.windowManager.hyprland.settings.misc.force_default_wallpaper = "-1"; # Set to -1 / 0 to enable / disable the anime mascot wallpapers
#  wayland.windowManager.hyprland.settings."device:epic-mouse-v1".sensitivity = "-0.5804929208180388";
  wayland.windowManager.hyprland.settings."$mainMod" = "SUPER";
  wayland.windowManager.hyprland.settings.bind = [
        "$mainMod_SHIFT, Q, exit,"
        "$mainMod_SHIFT, F, togglefloating,"
        "$mainMod_SHIFT, P, pseudo," # dwindle
        "$mainMod_SHIFT, J, togglesplit," # dwindle
        "$mainMod, Q, killactive,"
        "$mainMod, K, exec, ${pkgs.${Terminal}}/bin/${Terminal}"
        "$mainMod, B, exec, ${pkgs.${Browser}}/bin/${Browser}"
        "$mainMod, O, exec, ${pkgs.${Notes}}/bin/${Notes}"
        "$mainMod, V, exec, ${pkgs.${IDE}}/bin/${IDE}"
        "$mainMod, F, exec, ${pkgs.${Terminal}}/bin/${Terminal} ${pkgs.${Filer}}/bin/${Filer}"
        "$mainMod, space, exec, pkill rofi || rofi -show drun -show-icons"
#        "$mainMod, left, movefocus, l"
#        "$mainMod, right, movefocus, r"
#        "$mainMod, up, movefocus, u"
#        "$mainMod, down, movefocus, d"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod, right, workspace, e+1"
        "$mainMod, left, workspace, e-1"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
      ];
  # Move/resize windows with mainMod + LMB/RMB and dragging
  wayland.windowManager.hyprland.settings.bindm = [
                                                     "$mainMod, mouse:272, movewindow"
                                                     "$mainMod SHIFT, mouse:272, resizewindow"
                                                  ];
  wayland.windowManager.hyprland.settings.bindel = [
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86AudioRaiseVolume, exec, brightnessctl -d smc::kbd_backlight s +10"
        ", XF86AudioLowerVolume, exec, brightnessctl -d smc::kbd_backlight s 10-"
#        ", code:238, exec, brightnessctl -d smc::kbd_backlight s +10"
#        ", code:237, exec, brightnessctl -d smc::kbd_backlight s 10-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume -l 0.0 @DEFAULT_AUDIO_SINK@ 5%-"
      ];
  wayland.windowManager.hyprland.settings.bindl = [
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];
#OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO

  programs.waybar.enable = true;
  programs.waybar.package = pkgs.waybar;
  programs.waybar.settings.mainBar = {
        max-height = 1;
        layer = "top";
        modules-left = [ "custom/lock" "custom/power" "backlight" "battery" "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "custom/music" "pulseaudio" "cpu" "memory" "temperature" "network" "bluetooth" ];
        "custom/lock" = {
          tooltip = false;
          on-click = "hyprctl dispatch exit";
          format = "";
        };
        "custom/power" = {
          tooltip = false;
          on-click = "poweroff";
          format = " ";
        };
        "backlight" = {
          device = "intel_backlight";
          format = "{icon}";
          format-tooltip = "{percent}%";
          format-icons = ["  " "  " "  " "  " "  " "  " "  " "  " "  "];
          on-scroll-up = "brightnessctl set 1%+";
          on-scroll-down = "brightnessctl set 1%-";
          smooth-scrolling-threshold = "2400";
        };
        "battery" = {
          bat = "BAT0";
          adapter = "ADP0";
          interval = 4;
          states = {
            warning = 40;
            critical = 25;
          };
          format = "{icon}";
          format-warning = "{icon}";
          format-critical = "󱧦";
          format-charging = ["󰢟" "󰢜" "󰂆" "󰂇" "󰂈" "󰢝" "󰂉" "󰢞" "󰂊" "󰂋" "󰂅"];
          format-plugged = "";
          format-notcharging = "󰚦☠󰂃";
          format-full = "󰂄";
          format-alt = "{icon} {capacity}%";
          format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };
        "hyprland/workspaces" = {
          all-outputs = true;
          sort-by-name = true;
          format = "{icon}";
          on-click = {
            default = "activate";
            active = "~/devenv/rice/scripts/swww_randomize.sh";
          };
          format-icons = {
            active = "󱎴"; /*default = "󰍹";*/
             "1"= "󰲠";
             "2"= "󰲢";
             "3"= "󰲤";
             "4"= "󰲦";
             "5"= "󰲨";
             "6"= "󰲪";
             "7"= "󰲬";
             "8"= "󰲮";
             "9"= "󰲰";
             "10"= "󰿬";
          };
        };
        "hyprland/window" = {
          max-length = 84;
          separate-outputs = true;
        };
        "clock" = {
          interval = 1;
          format = "{:%Y/%m/%d 󱄅 %H:%M:%S}";
          on-click = "${NixDir}/.rice/scripts/waybar-calendar.sh";
        };
        "custom/music" = {
          format = " {}";
          escape = true;
          interval = 1;
          exec = "playerctl metadata --format='{{ title }}'";
          on-click = "playerctl play-pause";
          max-length = 24;
        };
        "pulseaudio" = {
          format = "{icon}";
          format-muted = " ";
          format-icons = {
            default = [" " " " " " "󰕾 " " "];
          };
          format-tooltip = "{@DEFAULT_AUDIO_SINK@}%";
          on-click = "wpctl set-volume -l 0.0 @DEFAULT_AUDIO_SINK@ 0%";
          on-scroll-up = "wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "wpctl set-volume -l 0.0 @DEFAULT_AUDIO_SINK@ 5%-";
          on-click-right = "wpctl set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 50%";
        };
        "cpu" = {
          interval = 4;
          format = "  {usage}%";
        };
        "memory" = {
          interval = 4;
          format = "  {}%";
          format-alt = "  {used:0.1f}GB";
        };
        "temperature" = {
          interval = 4;
#          hwmon-path = "/sys/class/hwmon/hwmon4/temp1_input";
          format-critical = "{temperatureC}°C {icon}";
          warning-threshold = 60;
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = ["󰜗" "" "" "" "" "" "󰈸"];
        };
        "network" = {
          fixed-width = 12;
          interval = 1;
          format-wifi = "{bandwidthDownBytes} {icon}";
          format-ethernet = "󰈀 ";
          format-disconnected = "󰤭 ";
          format-icons = ["󰤯 " "󰤟 " "󰤢 " "󰤥 " "󰤨 "];
          on-click = "kitty ${NixDir}/.rice/scripts/waybar-network.sh";
        };
        "bluetooth" = {
          interval = 30;
          format = "{icon}";
          format-icons = {
            disabled = "󰂲";
            disconnected = "󰂲";
            enabled = "";
          };
          format-disconnected = "󰂲";
          on-click = "${NixDir}/.rice/scripts/waybar-bluetooth-toggle.sh";
#          tooltip-format = "{sh -c 'bluetoothctl devices'}";
        };
  };

#OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
# radius - TL TR BR BL

  programs.waybar = {
    style = '' 
      /*
      * HASH GRAB: LIKELY NOT GLOBAL, NOT TESTED
      *
      * Catppuccin Mocha palette
      * Maintainer: rubyowo
      *
      */
      @define-color base   #1e1e2e;
      @define-color mantle #181825;
      @define-color crust  #11111b;
      @define-color text     #cdd6f4;
      @define-color subtext0 #a6adc8;
      @define-color subtext1 #bac2de;
      @define-color surface0 #313244;
      @define-color surface1 #45475a;
      @define-color surface2 #585b70;
      @define-color overlay0 #6c7086;
      @define-color overlay1 #7f849c;
      @define-color overlay2 #9399b2;
      @define-color blue      #89b4fa;
      @define-color lavender  #b4befe;
      @define-color sapphire  #74c7ec;
      @define-color sky       #89dceb;
      @define-color teal      #94e2d5;
      @define-color green     #a6e3a1;
      @define-color yellow    #f9e2af;
      @define-color peach     #fab387;
      @define-color maroon    #eba0ac;
      @define-color red       #f38ba8;
      @define-color mauve     #cba6f7;
      @define-color pink      #f5c2e7;
      @define-color flamingo  #f2cdcd;
      @define-color rosewater #f5e0dc;
* {
      font-family: Material Design Icons, FantasqueSansM Nerd Font ;
      font-size: 15.67px;
      border: none;
      margin: 0;
      padding: 0;
      }
      #waybar {
        background-color: rgba(30, 30, 46, 0.84);
        color: #ffffff;
        margin: 0 5px 0 5px;
      }
      #custom-lock {
        color: @overlay2;
        padding: 0 0.5rem 0 1rem;
      }
      #custom-power {
        color: @red;
        padding: 0 0.5rem 0 0.5rem;
      }
      #backlight {
        background: linear-gradient(to left, rgba(17, 17, 27, 0.52), rgba(17, 17, 27, 0.44));
        border-radius: 50px 0 0 10px; 
        color: @yellow; 
        padding: 0 0.5rem 0 1rem;
      }
      #battery {
        background: linear-gradient(to left, rgba(17, 17, 27, 0.60), rgba(17, 17, 27, 0.52));
        color: #8fbcbb;
        padding: 0 0.5rem 0 0.5rem; 
      }
      #battery.warning {
        color: #ecd3a0;
      }
      #battery.critical {
        color: #fbbcbb;
      }
      #battery.critical:not(.charging) {
        color: #fb958b;
      }
      #battery.charging { 
        color: #0bbcbb;
      }
      #battery.full {
        color: #00bcbb;
      }
      #battery.plugged {
        color: #8fbcbb;
      }
      @keyframes blink {
        to {
          color: #abb2bf;
        }
      }
      #workspaces {
        background: linear-gradient(to left, rgba(17, 17, 27, 0.96), rgba(17, 17, 27, 0.60));
        border-radius: 0 10px 75px 0;
        padding: 0 1rem 0 0.5rem;
      }
      #workspaces button {
        border-radius: 1rem;
        box-shadow: inset 0 -4px transparent;
        color: @lavender;
        padding: 0.2rem;
        transition: all 0.0s;
      }
      #workspaces button.active {
        border-radius: 1rem;
        color: @sky;
      }
      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
        margin-left: 0;
      }
      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
        margin-right: 0;
      }
      #workspaces button:hover {
        border-radius: 1rem;
        color: @sapphire;
      }
      #window {
        border-radius: 50px 10px 75px 25px;
        background: linear-gradient(to left, rgba(17, 17, 27, 0.69), rgba(17, 17, 27, 0.44));
        color: @teal;
        padding: 0 1rem 0 1rem;
      }
      window#waybar {
        background-color: transparent;
        color: #ffffff;
        transition-duration: 0.0s;
        transition-property: background-color;
      }
      window#waybar.hidden {
        opacity: 0.1;
      }
      window#waybar.empty #window {
        background-color: transparent;
      }
      #clock {
        background: radial-gradient(circle, rgba(17, 17, 27, 0.44), rgba(17, 17, 27, 0.69));
        border-radius: 22px 22px 222px 222px;
        color: #9399b2;
        margin: 0 1.4rem 0 0.4rem;
        padding: 0 1.5rem 0 1.5rem;
      }
      #custom-music {
        background: linear-gradient(to right, rgba(17, 17, 27, 0.69), rgba(17, 17, 27, 0.44));
        border-radius: 10px 50px 10px 50px;
        color: @lavender;
        padding: 0 1rem 0 1rem;
      }
      #pulseaudio {
        background: linear-gradient(to right, rgba(17, 17, 27, 0.96), rgba(17, 17, 27, 0.69));
        border-radius: 10px 0 0 50px;
        color: @sapphire;
        padding: 0 1rem 0 1rem;
      }
      #pulseaudio.muted {
        color: #fb958b;
      }
      #cpu {
        background: linear-gradient(to right, rgba(17, 17, 27, 0.69), rgba(17, 17, 27, 0.58));
        color: @yellow;
        padding: 0 0.5rem 0 0.5rem;
      }
      #memory {
        background: linear-gradient(to right, rgba(17, 17, 27, 0.58), rgba(17, 17, 27, 0.49));
        color: @teal;
        padding: 0 0.5rem 0 0.5rem;
      }
      #temperature {
        background: linear-gradient(to right, rgba(17, 17, 27, 0.49), rgba(17, 17, 27, 0.44));
        border-radius: 0 50px 10px 0;
        color: @maroon;
        padding: 0 1rem 0 0.5rem;
      }
      #network {
        color: #5E81AC;
        padding: 0 0.5rem 0 1rem;
      }
      #network.disconnected {
        color: #fb958b;
      }
      #bluetooth {
        color: #00bcbb;
        padding: 0 1rem 0 0.5rem;
      }
      #bluetooth.disconnected {
        color: @overlay2;
      }
      tooltip {
        font-family: "FantasqueSansM Nerd Font";
        background-color: #1f232b;
        padding: 0.5em;
        opacity: 0.8;
        font-size: 12px;
      }
      tooltip label {
        font-family: "FantasqueSansM Nerd Font";
        border-radius: 4px;
        padding: 0.5em;
        opacity: 0.8;
        font-size: 12px;
      }
      label:focus {
        background-color: #1f232b;
        border-radius: 4px;
        padding: 0.5em;
        opacity: 0.8;
        font-size: 12px;
      }
    '';
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  xdg.portal.config.common.default = "*";
  fonts.fontconfig.enable = true;
  systemd.user.startServices = "sd-switch";
}
