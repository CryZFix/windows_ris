@echo off

dism /mount-wim /wimfile:winpe.wim /index:1 /mountdir:mount
copy mount\Windows\Boot\PXE\bootmgr.exe .
copy mount\Windows\Boot\PXE\pxeboot.n12 .
for %%a in (".") do set CURRENT_DIR_NAME=%%~na
echo net use z: \\192.168.1.5\netboot\windows\%CURRENT_DIR_NAME% /user:install install>> mount\Windows\System32\startnet.cmd
echo z:>> mount\Windows\System32\startnet.cmd
IF %CURRENT_DIR_NAME%==11x64 (
  echo regedit /s bypass.reg>> mount\Windows\System32\startnet.cmd
)
echo \sources\setup.exe>> mount\Windows\System32\startnet.cmd
::"C:\Program Files\Notepad++\notepad++.exe" mount\Windows\System32\startnet.cmd
MD boot
copy ISO\boot\boot.sdi boot\.
copy ISO\boot\boot.sdi ..\..\boot\.
dism /unmount-wim /mountdir:mount /commit
move winpe.wim boot\.
del efis*
del etfs*
rd mount
rd ISO /s /q

::Create BCD loader
::cscript rep.vbs pxeboot.n12 bootmgr.exe pxeboot.0 %CURRENT_DIR_NAME%mgr.exe
::cscript rep.vbs bootmgr.exe \boot\bcd ..\..\%CURRENT_DIR_NAME%mgr.exe \boot\%CURRENT_DIR_NAME% /bootmgr
::editbin.exe ..\..\%CURRENT_DIR_NAME%mgr.exe /release
::call createbcd.cmd d:\netboot\boot\%CURRENT_DIR_NAME% \windows\%CURRENT_DIR_NAME%\boot\winpe.wim
::del createbcd.cmd editbin.exe link.exe mspdb80.dll rep.vbs test.txt bootmgr.exe pxeboot.n12

del MakePE.bat

:: Dism /Image:C:\test\offline /Add-Driver /Driver:c:\drivers /Recurse
