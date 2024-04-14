#! /bin/bash
STARTUP=/sdcard/.adb/startup.sh
if ! adb shell "[ -f $STARTUP ]" ; then 
    echo "file not found, push with adb"
    adb push "$(dirname "$0")/startup.sh" $STARTUP
fi
# for most shells, '-o emacs -o vi-tabcomplete' is the default, but for some it isn't.
adb shell -t "HOME='/sdcard' ENV='$STARTUP' sh -i -o emacs -o vi-tabcomplete"
