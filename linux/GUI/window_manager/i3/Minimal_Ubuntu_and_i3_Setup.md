# [Minimal Ubuntu and i3 Setup](https://ericren.me/posts/2019-01-27-minimal-ubuntu-tiling-wm-setup/)

- [Minimal Ubuntu and i3 Setup](#minimal-ubuntu-and-i3-setup)
  - [Install Desktop](#install-desktop)
    - [X Window System](#x-window-system)
      - [Notes:](#notes)
      - [Reference:](#reference)
    - [Adding a terminal emulator](#adding-a-terminal-emulator)
    - [Changing terminal colors and font (Optional)](#changing-terminal-colors-and-font-optional)
    - [Tiling Window Manager](#tiling-window-manager)
    - [Exiting i3](#exiting-i3)

## Install Desktop

### X Window System

We’ll need a display server so let’s install the one most widely used; [Xorg](https://wiki.archlinux.org/index.php/Xorg):

    sudo apt install xinit

#### Notes:

- Configuration files are stored in `/etc/X11/xinit/`.

- If ~/.xinitrc is not specified, /etc/X11/xinit/xinitrc will run.

  - Same override logic applies for ~/.xserverrc.

For now, we don’t have to worry about adding any configuration for X.

#### Reference:

https://wiki.archlinux.org/index.php/Xinit

### Adding a terminal emulator

Because we plan on using a terminal in a GUI environment, we need to install a terminal emulator.

There are so many terminal emulators out there, all with varying degrees of features, quality, pouplarity, maintainability, etc. I suggest doing some research if you have the time and care strongly about which one to use.

I pesonally picked [rxvt-unicode](https://wiki.archlinux.org/index.php/Rxvt-unicode).

### Changing terminal colors and font (Optional)

We can make the terminal easier on the eyes with [base 16 color scheme](https://github.com/chriskempson/base16-xresources). I You can choose whichever colour shceme you want; I chose `solarized-dark-256`.

Let’s fetch the dark color scheme and save it as `~/.Xresource`s:

    curl https://raw.githubusercontent.com/chriskempson/base16-xresources/master/xresources/base16-solarized-dark-256.Xresources >> ~/.Xresources
    xrdb -load ~/.Xresources

And change the default font type and size by appending this to ~/.Xresources:

    URxvt.font: xft:DejaVuSansMono:size=10

### Tiling Window Manager

Now we finally get to installing the tiling window manager!

Similar to the situation with terminal emulators, there are [quite a few window managers to choose from](https://www.gilesorr.com/wm/table.html). I chose [i3](https://i3wm.org/) because of its been in use for awhile, is well-known, and extensible (also easy potential migration to [sway](https://ericren.me/posts/2019-01-27-minimal-ubuntu-tiling-wm-setup/) for future [Wayland](https://wayland.freedesktop.org/) support).

    sudo apt install i3

Now start `X`:

    startx

There will be prompts to create a config file, and to choose which key as yourkey. I just chose Yes and the default windows key.

### Exiting i3

To exit i3, press `<mod>-<shift>-e`. Pressing ‘Yes’ with the mouse will stop the session.

If you didn’t install a terminal emulator previously, you might be frustrated that pressing the button doesn’t do anything. In this case, you’ll have to either: - Force shutdown and boot up your computer via power management (e.g, press and hold power button) - Go to another `tty` (virtual terminal) via `<ctrl>-<alt>-<f2...?>` and login. For my laptop, Fn2…Fn6 corresponds to tty2…tty6.















apt install xserver-xorg
apt install i3status

https://linoxide.com/gui/install-i3-window-manager-linux/
