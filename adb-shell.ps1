$STARTUP = "/sdcard/.adb/startup.sh"
adb shell "[ -f $STARTUP ]" ; 
if (-not $?){ # $?: command success status (true if the last command was successful)
    Write-Output "file not found, push with adb"
    adb push "$PSScriptRoot/startup.sh" $STARTUP
}
adb shell -t "HOME='/sdcard' ENV='$STARTUP' sh -i -o emacs -o vi-tabcomplete"