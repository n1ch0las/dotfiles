# Without a DM, we need to make some declarations
export XDG_SESSION_TYPE=x11
export XDG_SESSION_DESKTOP=i3
export XDG_CURRENT_DESKTOP=i3
export GTK_USE_PORTAL=0

# Set Fcitx environment variables
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFERS=@im=fcitx
export INPUT_METHOD=fcitx

# Keycode 63, KP_Multiply, is broken. Once X starts, disable the problem key.
# If you want to disable it more widely, try loading a custom keymap in /etc/vconsole.conf
xmodmap ~/.xmodmap

# Set terminal theme
xrdb -merge ~/.Xresources

# Start the window manager
exec i3
