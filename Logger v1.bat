@mode 17,1
:start
@echo off
chcp 65001 > nul



	cd /d %~dp0
	set "CurrentLocation=%~dp0"
	set "Logfile=%~dp0Log_Entry.txt"
	set "VBscript0=%~dp0vbs.vbs"
	set "Startup=C:\Users\User\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\"
	set "Start=C:\ProgramData\Microsoft\Windows\Start Menu\Programs"
	set D=100

	if not exist "%Startup%StartLogger.vbs"	goto filesnoexist
	if not exist "%start%Log.bat"			goto filesnoexist
	
::setlocal enabledelayedexpansion
::set dt=%date:~10,4%%date:~4,2%%date:~7,2%
::for /r "%~dp0" %%X IN (Log_Entry.txt) DO (
::   set ModDt=%%~tX
::   rem %ModDt%  
::   )
::	rem [%ModDt:~0,10%]:[%date%]
::	If %ModDt:~0,10%==%date% goto exit

echo. >> %Logfile%
echo [%time% %date%][%systemdrive%][%os%][%computername%][%username%] >> %Logfile%
echo       No Description Added >> %Logfile%

timeout /t 1 >nul

echo Set WShell = CreateObject("WScript.Shell")				  >> %VBscript0%
echo Set WshShell = WScript.CreateObject("WScript.Shell")  >> %VBscript0%
echo WShell.Run("Notepad.exe %~dp0%Logfile%")				  >> %VBscript0%
echo WScript.Sleep 500											     >> %VBscript0%
echo WshShell.AppActivate "Notepad"							     >> %VBscript0%
echo WshShell.SendKeys "^{END}"                            >> %VBscript0%
echo WshShell.SendKeys "^{END}"                            >> %VBscript0%
echo WshShell.SendKeys "^{END}"                            >> %VBscript0%

timeout /t 1 >nul
start /wait %VBscript0%
timeout /t 1 >nul
del  %VBscript0%

	::echo Set WShell = CreateObject("WScript.Shell")				  >> %VBscript0%
	::echo Set WshShell = WScript.CreateObject("WScript.Shell")  >> %VBscript0%
	::echo WShell.Run("Notepad.exe %~dp0%Logfile%")				  >> %VBscript0%
	::echo WshShell.AppActivate "Notepad"							     >> %VBscript0%
	::echo WScript.Sleep 500											     >> %VBscript0%
	::echo WshShell.SendKeys "^a"										  >> %VBscript0%
	::echo WScript.Sleep 200												  >> %VBscript0%
	::echo WshShell.SendKeys "{DOWN}"									  >> %VBscript0%
	::echo WScript.Sleep %D%												  >> %VBscript0%
	::echo WshShell.SendKeys "{ENTER}"								     >> %VBscript0%
	::echo WScript.Sleep %D%											     >> %VBscript0%
	::echo WshShell.SendKeys "{ENTER}"									  >> %VBscript0%
	::echo WScript.Sleep %D%												  >> %VBscript0%
	::echo WshShell.SendKeys "[%time% %date%][%systemdrive%][%os%][%computername%][%username%]" >> %VBscript0%
	::echo WScript.Sleep %D%											     >> %VBscript0%
	::echo WshShell.SendKeys "{ENTER}"									  >> %VBscript0%
	::echo WScript.Sleep %D%												  >> %VBscript0%
	::echo WshShell.SendKeys "{TAB}"									  >> %VBscript0%
	::echo WScript.Sleep %D%												  >> %VBscript0%
	::echo WshShell.SendKeys "No Description Added"				  >> %VBscript0%
	::echo WScript.Sleep %D%												  >> %VBscript0%
	::echo WshShell.SendKeys "^s"										  >> %VBscript0%
	::echo WScript.Sleep %D%												  >> %VBscript0%


	::goto skiploop
	:::waitloop
	::TASKLIST |find /I "notepad.exe" >NUL
	::IF ERRORLEVEL 1 GOTO endloop
	::timeout /t 1 /nobreak>NUL
	::goto waitloop
	:::endloop
	::echo Done!
	:::skiploop



exit

:filesnoexist

	if not "%1"=="am_admin" (
		powershell -Command "Start-Process -Verb RunAs -FilePath '%0' -ArgumentList 'am_admin'"
		exit /b
	)

	cd /d %~dp0

	set Startup=C:\Users\User\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\
	set Start=C:\ProgramData\Microsoft\Windows\Start Menu\Programs
	set ThisFile=Logger.bat

	del "%start%Log.bat"
	timeout /t 1 /nobreak
	echo @echo off				                                >> "%start%Log.bat"
	echo start "Log" "%~dp0%ThisFile%"	                    >> "%start%Log.bat"

	del "%Startup%startlog.vbs"
	timeout /t 1 /nobreak
	echo Set WShell = CreateObject("WScript.Shell")	        >> "%Startup%startlog.vbs"
	echo WScript.Sleep 10000				                    >> "%Startup%startlog.vbs"
	echo WShell.Run("%~dp0%Thisfile%")			              >> "%Startup%startlog.vbs"
    
goto start

:exit
exit

::version	0.8
::Made by	User
::Updated	16:35 30/08/2022

