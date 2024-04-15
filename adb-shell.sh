#! /bin/bash
STARTUP=/sdcard/.adb/startup.sh
adb shell "[ -f $STARTUP ] || exit 6";
last_exit_status=$?

if [ $last_exit_status -eq 6 ] ; then
    echo "file not found, push with adb"
    adb push "$(dirname "$0")/startup.sh" $STARTUP

elif [ $last_exit_status -eq 1 ]; then # adb error
    exit 1
fi
# for most shells, '-o emacs -o vi-tabcomplete' is the default, but for some it isn't.
adb shell -t "HOME='/sdcard' ENV='$STARTUP' sh -i -o emacs -o vi-tabcomplete"
