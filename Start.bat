@echo off

C:
cd c:\Program Files\Windows AIK\Tools\PETools

MD d:\netboot\boot
xcopy d:\src\syslinux\* d:\netboot\ /s /e /y /i
FOR %%a IN (10x64) do (
	call copype.cmd amd64 d:\netboot\windows\%%a
	copy d:\src\pe\* d:\netboot\windows\%%a\.
	cd d:\netboot\windows\%%a
	call MakePE.bat
  IF %%a==11x64 (
    copy d:\src\bypass.reg d:\netboot\windows\%%a\.
  )
	)
