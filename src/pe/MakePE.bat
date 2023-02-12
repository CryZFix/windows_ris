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

IF %CURRENT_DIR_NAME%==7x64 (
  cscript rep.vbs pxeboot.n12 bootmgr.exe pxeboot.0 000tmgr.exe
  cscript rep.vbs bootmgr.exe \boot\bcd ..\..\000tmgr.exe \boot\000 /bootmgr
  editbin.exe ..\..\000tmgr.exe /release
  call createbcd.cmd d:\netboot\boot\000 \windows\7x64\boot\winpe.wim
  del createbcd.cmd editbin.exe link.exe mspdb80.dll rep.vbs test.txt bootmgr.exe pxeboot.n12
)
IF %CURRENT_DIR_NAME%==8x64 (
  cscript rep.vbs pxeboot.n12 bootmgr.exe pxeboot.0 001tmgr.exe
  cscript rep.vbs bootmgr.exe \boot\bcd ..\..\001tmgr.exe \boot\001 /bootmgr
  editbin.exe ..\..\001tmgr.exe /release
  call createbcd.cmd d:\netboot\boot\001 \windows\8x64\boot\winpe.wim
  del createbcd.cmd editbin.exe link.exe mspdb80.dll rep.vbs test.txt bootmgr.exe pxeboot.n12
)
IF %CURRENT_DIR_NAME%==10x64 (
  cscript rep.vbs pxeboot.n12 bootmgr.exe pxeboot.0 002tmgr.exe
  cscript rep.vbs bootmgr.exe \boot\bcd ..\..\002tmgr.exe \boot\002 /bootmgr
  editbin.exe ..\..\002tmgr.exe /release
  call createbcd.cmd d:\netboot\boot\002 \windows\10x64\boot\winpe.wim
  del createbcd.cmd editbin.exe link.exe mspdb80.dll rep.vbs test.txt bootmgr.exe pxeboot.n12
)
IF %CURRENT_DIR_NAME%==11x64 (
  cscript rep.vbs pxeboot.n12 bootmgr.exe pxeboot.0 003tmgr.exe
  cscript rep.vbs bootmgr.exe \boot\bcd ..\..\003tmgr.exe \boot\003 /bootmgr
  editbin.exe ..\..\003tmgr.exe /release
  call createbcd.cmd d:\netboot\boot\003 \windows\11x64\boot\winpe.wim
  del createbcd.cmd editbin.exe link.exe mspdb80.dll rep.vbs test.txt bootmgr.exe pxeboot.n12
)
del MakePE.bat

:: Dism /Image:C:\test\offline /Add-Driver /Driver:c:\drivers /Recurse
