#
#  KDE Plasma 6 Configuration
#  Enable with "kde.enable = true;"
#  Get the plasma configs in a file with $ nix run github:pjones/plasma-manager > <file>
#

{ config, lib, pkgs, vars, inputs, ... }:

with lib;
{
  config = mkIf (config.kde.enable) {
    services.gnome.core-utilities.enable = false;
    programs = {
      kdeconnect = {
        enable = true;
      };
    };

    services = {
      displayManager = {
        sddm.enable = true;
        sddm.wayland.enable = true;
        defaultSession = "plasma";
      };
      desktopManager.plasma6 = {
        enable = true;
        # enableQt5Integration = false;
      };
      libinput.enable = true;
      xserver = {
        enable = true;
        xkb = {
          layout = "us";
          options = "eurosign:e";
        };
        modules = [ pkgs.xf86_input_wacom ];
        wacom.enable = true;
      };
    };

    qt = {
      enable = true;
      platformTheme = "kde";
      style = "breeze";
    };

    environment = {
      sessionVariables = {
        GTK_USE_PORTAL = "1";
        GTK_THEME = "Breeze";
        NIXOS_OZONE_WL = "1";
      };
      systemPackages = with pkgs.kdePackages; [
        packagekit-qt # Package Updater
      ];
      plasma5.excludePackages = with pkgs.libsForQt5; [
        plasma-browser-integration
      ];
      plasma6.excludePackages = with pkgs.kdePackages; [
        oxygen
      ];
    };

    home-manager.users.${vars.user} = {
      home.pointerCursor = {
        x11.enable = true;
        name = "breeze_cursors";
        size = 24;
        package = pkgs.kdePackages.breeze;
      };
      gtk = {
        enable = false; # Doesn't work well because KDE overrides ~/.gtkrc-2.0 after login
        theme.name = "Breeze";
        iconTheme.name = "breeze-dark";
        cursorTheme = {
          name = "breeze_cursors";
          size = 24;
        };
        gtk3.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
        gtk4.extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
      };

      imports = [
        inputs.plasma-manager.homeManagerModules.plasma-manager
      ];
      programs.plasma = {
        enable = true;
        workspace = {
          clickItemTo = "open";
          colorScheme = "BreezeDark";
          lookAndFeel = "org.kde.breezedark.desktop";
          iconTheme = "breeze-dark";
          theme = "breeze-dark";
          cursor = {
            theme = "breeze_cursors";
            size = 24;
          };
        };

        kscreenlocker.autoLock = false;

        panels = [
          {
            location = "bottom";
            widgets = [
              {
                kickoff = {
                  sortAlphabetically = true;
                  icon = "nix-snowflake-white";
                };
              }
              {
                pager = {
                  general = {
                    showWindowOutlines = true;
                    showApplicationIconsOnWindowOutlines = true;
                    showOnlyCurrentScreen = true;
                    navigationWrapsAround = true;
                    displayedText = "desktopNumber";
                    selectingCurrentVirtualDesktop = "doNothing";
                  };
                };
              }
              {
                iconTasks = {
                  launchers = [
                    "applications:firefox.desktop"
                    "applications:systemsettings.desktop"
                    "applications:org.kde.dolphin.desktop"
                    "applications:org.kde.konsole.desktop"
                    "applications:org.kde.kate.desktop"
                  ];
                  behavior = {
                    showTasks = {
                      onlyInCurrentScreen = true;
                      onlyInCurrentDesktop = true;
                      onlyInCurrentActivity = true;
                    };
                  };
                };
              }
              "org.kde.plasma.marginsseparator"
              {
                systemTray.items = {
                  shown = [
                    "org.kde.plasma.battery"
                  ];
                  hidden = [
                    "org.kde.plasma.addons.katesessions"
                  ];
                  configs = {
                    battery.showPercentage = true;
                  };
                };
              }
              {
                digitalClock = {
                  time = {
                    showSeconds = "always";
                    format = "24h";
                  };
                  calendar = {
                    firstDayOfWeek = "monday";
                    showWeekNumbers = true;
                    plugins = [ "holidaysevents" "astronomicalevents" ];
                  };
                };
              }
              "org.kde.plasma.showdesktop"
            ];
            hiding = "none";
            floating = false;
          }
        ];

        window-rules = [
          {
            description = "Plasma Desktop Workspace";
            match = {
              window-class = {
                value = "org.kde.plasmashell";
                type = "exact";
                match-whole = false;
              };
            };
            apply = {
              skippager = {
                value = true;
                apply = "force";
              };
              skipswitcher = {
                value = true;
                apply = "force";
              };
              skiptaskbar = {
                value = true;
                apply = "force";
              };
            };
          }
          {
            description = "Discord";
            match = {
              window-class = {
                value = "discord";
                type = "exact";
                match-whole = false;
              };
              title = {
                value = "Discord$|Discord Updater";
                type = "regex";
              };
            };
            apply = {
              maximizehoriz = {
                value = true;
                apply = "initially";
              };
              maximizevert = {
                value = true;
                apply = "initially";
              };
              screen = {
                value = 1;
                apply = "remember";
              };
              activity = {
                value = "Communication";
                apply = "force";
              };
              desktops = {
                value = "Desktop_1";
                apply = "force";
              };
            };
          }
          {
            description = "Ferdi";
            match = {
              window-class = {
                value = "^ferdi";
                type = "regex";
                match-whole = false;
              };
              title = {
                value = "^Ferdi";
                type = "regex";
              };
            };
            apply = {
              maximizehoriz = {
                value = true;
                apply = "initially";
              };
              maximizevert = {
                value = true;
                apply = "initially";
              };
              screen = {
                value = 2;
                apply = "remember";
              };
              activity = {
                value = "Communication";
                apply = "force";
              };
              desktops = {
                value = "Desktop_1";
                apply = "force";
              };
            };
          }
        ];

        powerdevil = {
          AC = {
            autoSuspend = {
              action = "nothing";
            };
            dimDisplay.enable = false;
            powerProfile = "performance";
            turnOffDisplay.idleTimeout = "never";
          };
          battery = {
            autoSuspend = {
              action = "sleep";
              idleTimeout = 600;
            };
            whenSleepingEnter = "standby";
            dimDisplay = {
              idleTimeout = 300;
            };
            powerProfile = "powerSaving";
            turnOffDisplay = {
              idleTimeout = 600;
            };
          };
          lowBattery = {
            whenLaptopLidClosed = "shutDown";
            powerProfile = "powerSaving";
          };
          batteryLevels = {
            criticalLevel = 3;
            lowLevel = 10;
            criticalAction = "shutDown";
          };
        };

        kwin = {
          effects = {
            blur.enable = true;
            dimAdminMode.enable = true;
            wobblyWindows.enable = true;
            minimization.animation = "magiclamp";
          };
          nightLight = {
            enable = true;
            location.latitude = "52";
            location.longitude = "13";
            mode = "location";
            temperature.night = 2700;
          };
          titlebarButtons = {
            left = [ "more-window-actions" ];
            right = [ "keep-above-windows" "minimize" "maximize" "close" ];
          };
          virtualDesktops = {
            number = 4;
            rows = 1;
            names = [
              "Desktop 1"
              "Desktop 2"
              "Desktop 3"
              "Desktop 4"
            ];
          };
        };

        shortcuts = {
          "org.kde.konsole.desktop"."_launch" = "Ctrl+Alt+T";
          kwin = {
            "Switch One Desktop to the Left" = "Ctrl+Alt+Left";
            "Switch One Desktop to the Right" = "Ctrl+Alt+Right";
            "Window Close" = "Alt+F4\tMeta+Q";
            "Kill Window" = "Meta+Ctrl+Esc\tCtrl+Alt+Esc";
            "Expose" = "Ctrl+F9\tMeta+A";
            "Window Maximize" = "Meta+PgUp\tMeta+Up";
            "Window Quick Tile Top" = "none";
            "Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left\tCtrl+Alt+Shift+Left";
            "Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right\tCtrl+Alt+Shift+Right";
          };
          mediacontrol.playpausemedia = "Media Play\tCtrl+Alt+D";
          plasmashell."manage activities" = "none";
          plasmashell."switch to next activity" = "Meta+Tab";
        };

        hotkeys.commands = {
          "change-keyboard-layout" = {
            name = "Change Keyboard Layout";
            key = "Ctrl+Alt+K";
            command = "\"~/bin/change-keyboard-layout\"";
            logs.enabled = false;
          };
          "xrandr-display" = {
            name = "Toggle Display";
            key = "Ctrl+Alt+Shift+S";
            command = "\"~/bin/xrandr-display && ~/bin/switch-display linux && xdotool key ctrl+alt+shift+d\"";
            logs.enabled = false;
          };
          "switch-windows" = {
            name = "Switch Display to Windows Output";
            key = "Ctrl+Alt+Shift+A";
            command = "\"~/bin/switch-display windows\"";
            logs.enabled = false;
          };
          "reload-plasma" = {
            name = "Reload Plasma";
            key = "Meta+Shift+K";
            command = "\"systemctl --user restart plasma-plasmashell\"";
            logs.enabled = false;
          };
        };

        configFile = {
          plasmashellrc."Notification Messages".klipperClearHistoryAskAgain = false;
          ksmserverrc.General.loginMode = "emptySession";
          ksmserverrc.General.shutdownType = 2;
          kwinrc.MouseBindings.CommandActiveTitlebar2 = "Minimize";
          kwinrc.MouseBindings.CommandAllWheel = "Maximize/Restore";
          kwinrc.MouseBindings.CommandInactiveTitlebar2 = "Minimize";
          kwinrc.MouseBindings.CommandTitlebarWheel = "Previous/Next Desktop";
          kwinrc.Windows.DelayFocusInterval = 0;
          kwinrc.Windows.FocusPolicy = "FocusFollowsMouse";
          kwinrc.Windows.NextFocusPrefersMouse = true;
          kcminputrc.Mouse.XLbInptAccelProfileFlat = true;
          kded5rc.Module-device_automounter.autoload = false;
          kactivitymanagerdrc.activities.Default = "Default";
          kactivitymanagerdrc.activities.Communication = "Communication";
          kactivitymanagerdrc.activities-icons.Default = "activities";
          kactivitymanagerdrc.activities-icons.Communication = "activities";
          kactivitymanagerdrc.main.currentActivity = "Default";
          kxkbrc.Layout.Use = true;
          kxkbrc.Layout.Options = "grp:win_space_toggle,caps:escape";
          kxkbrc.Layout.ResetOldOptions = true;
          kxkbrc.Layout.ShowLayoutIndicator = true;
          systemsettingsrc.systemsettings_sidebar_mode.HighlightNonDefaultSettings = true;
          "flameshot/flameshot.ini".General.showDesktopNotification = false;
          "flameshot/flameshot.ini".General.showStartupLaunchMessage = false;
        };

        dataFile = {
          "dolphin/view_properties/global/.directory"."Dolphin"."SortRole" = "modificationtime";
          "dolphin/view_properties/global/.directory"."Dolphin"."ViewMode" = 1;
          "dolphin/view_properties/global/.directory"."Settings"."HiddenFilesShown" = true;
        };

      };
    };
  };
}
