#!/bin/bash

nmcli device show | awk -v sig="$(nmcli -f ACTIVE,SSID,SIGNAL dev wifi | awk '/^yes/ {print $2, $3}')" '
BEGIN {
  split(sig, s); strength = s[2]
}
/^GENERAL.DEVICE:/ {
  if (dev && (dev == "wlan0" || dev == "enp7s0")) {
    printf " ${color grey}Device  ${color}%s\n ${color grey}Type    ${color}%s\n ${color grey}State   ${color}%s\n", dev, type, state
    if (dev == "wlan0" && conn != "--") {
      if (state == "connected") {
        printf " ${color grey}SSID    ${color}%s (%s%%)\n", conn, strength
      } else {
        printf " ${color grey}SSID    ${color}%s\n", conn
      }
    }
    printf " ${color grey}IP4     ${color}%s\n\n", ip
  }
  dev=$2; type=state=conn=ip="--"
}
/^GENERAL.TYPE:/ && (dev=="wlan0" || dev=="enp7s0") {
  type=$2
}
/^GENERAL.STATE:/ && (dev=="wlan0" || dev=="enp7s0") {
  match($0, /\(([^)]+)\)/, m)
  state = m[1]
  if (index(state, "connecting") == 1) {
    state = "getting IP config..."
  }
}
/^GENERAL.CONNECTION:/ && (dev=="wlan0" || dev=="enp7s0") {
  conn=substr($0, index($0,$2))
}
/^IP4.ADDRESS\[1\]:/ && (dev=="wlan0" || dev=="enp7s0") {
  split($2, parts, "/")
  ip=parts[1]
}
END {
  if (dev && (dev == "wlan0" || dev == "enp7s0")) {
    printf " ${color grey}Device  ${color}%s\n ${color grey}Type    ${color}%s\n ${color grey}State   ${color}%s\n", dev, type, state
    if (dev == "wlan0" && conn != "--") {
      if (state == "connected") {
        printf " ${color grey}SSID    ${color}%s (%s%%)\n", conn, strength
      } else {
        printf " ${color grey}SSID    ${color}%s\n", conn
      }
    }
    printf " ${color grey}IP4     ${color}%s\n", ip
  }
}'
