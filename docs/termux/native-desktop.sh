#!/data/data/com.termux/files/usr/bin/bash

# Usage:
#   ./native-desktop.sh start
#   ./native-desktop.sh stop

start_desktop() {
  # Kill open X11 processes (fresh start)
  kill -9 $(pgrep -f "termux.x11") 2>/dev/null

  # Enable PulseAudio over Network
  pulseaudio --start --load="module-native-protocol-tcp auth-ip-acl=127.0.0.1 auth-anonymous=1" --exit-idle-time=-1

  # Prepare termux-x11 session
  export XDG_RUNTIME_DIR=${TMPDIR}
  termux-x11 :0 >/dev/null 2>&1 &

  # Wait a bit until termux-x11 gets started
  sleep 3

  # Launch Termux X11 main activity
  am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity >/dev/null 2>&1
  sleep 1

  # Set audio server
  export PULSE_SERVER=127.0.0.1

  # Run XFCE4 Desktop silently in background
  env DISPLAY=:0 dbus-launch --exit-with-session xfce4-session >/dev/null 2>&1 &

  echo "XFCE Desktop and Termux-X11 started successfully!"
}

stop_desktop() {
  # Suppress all error and warning logs
  exec 2>/dev/null

  # Kill XFCE4, Termux-X11, and DBus processes
  kill -9 $(pgrep -f "xfce4|termux.x11|dbus-launch") 2>/dev/null

  # Kill PulseAudio sound server
  pulseaudio --kill 2>/dev/null

  echo "XFCE Desktop and Termux-X11 stopped successfully!"
}

case "$1" in
start)
  start_desktop
  ;;
stop)
  stop_desktop
  ;;
*)
  echo "Usage: $0 {start|stop}"
  exit 1
  ;;
esac

exit 0
