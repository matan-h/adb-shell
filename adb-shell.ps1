$STARTUP = "/sdcard/.adb/startup.sh"
adb shell "[ -f $STARTUP ] || exit 6" ; 
if ($LastExitCode -eq 6){ # $?: command success status (true if the last command was successful)
    Write-Output "file not found, push with adb"
    adb push "$PSScriptRoot/startup.sh" $STARTUP
}
if ($LastExitCode -eq 1){ # adb error
    exit 1
}
adb shell -t "HOME='/sdcard' ENV='$STARTUP' sh -i -o emacs -o vi-tabcomplete"