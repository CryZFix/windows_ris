bcdedit -createstore %1
bcdedit -store %1 -create {ramdiskoptions} /d "Ramdisk options" 
bcdedit -store %1 -set {ramdiskoptions} ramdisksdidevice boot
bcdedit -store %1 -set {ramdiskoptions} ramdisksdipath \boot\boot.sdi
for /F "tokens=2 delims={}" %%i in ('bcdedit -store %1 -create /d "MyWinPE Boot Image" /application osloader') do set guid={%%i}
bcdedit -store %1 -set %guid% systemroot \Windows
bcdedit -store %1 -set %guid% detecthal Yes
bcdedit -store %1 -set %guid% winpe Yes
bcdedit -store %1 -set %guid% osdevice ramdisk=[boot]%2,{ramdiskoptions}
bcdedit -store %1 -set %guid% device ramdisk=[boot]%2,{ramdiskoptions}
bcdedit -store %1 -create {bootmgr} /d "Windows BootManager"
bcdedit -store %1 -set {bootmgr} nointegritychecks Yes timeout 30 
bcdedit -store %1 -set {bootmgr} displayorder %guid%