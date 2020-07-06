#!/bin/sh

password="android"
password_view_only="docker"

/usr/bin/expect <<EOF
spawn vncpasswd
expect "Password:"
send "$password\r"
expect "Verify:"
send "$password\r"
expect "Would you like to enter a view-only password (y/n)?"
send "y\r"
expect "Password:"
send "$password_view_only\r"
expect "Verify:"
send "$password_view_only\r"
expect eof
exit
EOF

# Source : https://raw.githubusercontent.com/thyrlian/AndroidSDK/master/android-sdk/vnc/vncpass.sh