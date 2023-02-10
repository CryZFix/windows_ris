Const adTypeText=2
Const adSaveCreateOverWrite=2
Const adSaveCreateNotExist=1 

Function txt2uni (str)
  length=Len(str)
  For i=1 To length-1
    txt2uni=txt2uni & Mid(str,i,1) & Chr(&H00)
  Next
  txt2uni=txt2uni & Mid(str,length,1)
End Function

version="REP.VBS версия 0.3"
description="Данный скрипт предназначен для редактирования бинареых файлов" & vbCRLF & _
            "Написан специально для использования совместно со статьей" & vbCRLF & _
            "PXELINUX и новые возможности установки Windows XP" & vbCRLF & _
            "http://unattendedxp.com/articles/pxelinux/" & vbCRLF
help="Параметры запуска" & vbCRLF & _
     "cscript rep.vbs <имя файла1> <текст1> <имя файла2> <текст2> [/force]" & vbCRLF & vbCRLF & _
     "<имя файла1> - имя исходного файла." & vbCRLF & _
     "<текст1> - текст, для поиска в <имя файла1>" & vbCRLF & _
     "<имя файла2> - имя выходного файла." & vbCRLF & _
     "<текст2> - текст, на который будет заменен <текст1>" & vbCRLF & _
     "/force - при указывающий данного параметра будет осуществлена" & vbCRLF & _
     "         пренудительная перезапись существующего файла" & vbCRLF & _
     "/bootmgr - указывающий данного параметра необходимо при работе с файлом" & vbCRLF & _
     "           bootmgr.exe (Vista/Windows7/Server2008)" & vbCRLF

wscript.echo version
wscript.echo description
if (InStr(1, WScript.FullName, "cscript.exe", 1)=0) then
	wscript.echo help
	WScript.Quit
end if

'Обработка параметров командной строки.
Set objArgs = WScript.Arguments
count=objArgs.Count
if count=0 then 
	wscript.echo help
	WScript.Quit
else
        overwrite=objArgs.named.exists("force")
        bootmgr=objArgs.named.exists("bootmgr")

	if count=4 or count<7 then
	  	fname1=objArgs(0)
		txt1=objArgs(1)
	  	fname2=objArgs(2)
		txt2=objArgs(3)
	else
		wscript.echo help
                Wscript.echo "Не достаточно аргументов"
		WScript.Quit
	End if
End if
if not overwrite then
   Set fso = CreateObject("Scripting.FileSystemObject")
   If (fso.FileExists(fname2)) Then
     wscript.echo "Файл " & fname2 & " уже существует"
     wscript.echo "Возможно, Вы забыли указать ключ /force"
     wscript.echo "Дальнейшее выполнение не возможно"
     WScript.Quit
   end if
end if

'Создаем стрим для чтения двоичного файла
set oStream = createobject("Adodb.Stream")
oStream.type = adTypeText
oStream.Charset = "windows-1251"
oStream.Open
oStream.LoadFromFile fname1
fc=oStream.ReadText
oStream.close

if bootmgr Then
  txt1=txt2uni(txt1)
  txt2=txt2uni(txt2)
End if

bidx=1
idx=instr(bidx,fc,txt1,1)
Do While idx>0 
	str=str & Mid(fc,bidx,idx-bidx) & txt2
	bidx=idx+Len(txt2)
	idx=instr(bidx,fc,txt1,1)
Loop
if Not bidx=1 then 
	str=str & right(fc,Len(fc)+1-bidx)
End if

'Создаем стрим для записи двоичного файла
oStream.type = adTypeText
oStream.Charset = "windows-1251"
oStream.open
oStream.WriteText=str
if overwrite then 
  oStream.SaveToFile fname2, adSaveCreateOverWrite
else
  oStream.SaveToFile fname2, adSaveCreateNotExist
end if
wscript.echo "Операция выполнена успешно"