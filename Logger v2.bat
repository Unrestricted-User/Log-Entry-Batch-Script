@echo off
@mode 17,1
chcp 65001 > nul


call :Variables

if exist "%Startup%\Create_Log_OnBoot.bat" if exist "%Startup%\Create_Log_OnBoot.bat" goto skipadmin
    net session >nul 2>&1
    if %errorLevel% neq 0 (
        powershell -Command "Start-Process '%0' -Verb RunAs"
        exit /b
        )
    :skipadmin

if not exist %Archive% ( 
    echo. >> x.txt
    %Zip% a -t7z -m0=lzma2 -mx=9 -mfb=273 -md=256m -ms=on %Archive% x.txt
    timeout /t 1 >nul
    %Zip% d %Archive% x.txt
    if exist x.txt ( erase /q x.txt )
    )

@mode 100,100
    setlocal enabledelayedexpansion
    for /r "%~dp0" %%X IN (Log_Entry.txt) DO ( set ModDt=%%~tX )
	set "ModDt=%ModDt:~0,10%"
    set "MDTYear=%ModDt:~6,4%"
    set "MDTMonth=%ModDt:~3,2%"
    set "MDTDay=%ModDt:~0,2%"
    set "MDT=%MDTYear%-%MDTMonth%-%MDTDay%"
    copy "%logfile%"  "%Logfile:~0,-4%_%MDT:~0,10%.txt" >nul
    %Zip% a -t7z -m0=lzma2 -mx=9 -mfb=273 -md=256m -ms=on %Archive% "%Logfile:~0,-4%_%MDT:~0,10%.txt" >nul
    timeout /t 1 >nul
    erase /q          "%Logfile:~0,-4%_%MDT:~0,10%.txt" >nul

if not exist "%Startup%\Create_Log_OnBoot.bat" call :createonboot
if not exist "%Start%\Create_Log.bat"          call :createmanual

for /f "usebackq delims=" %%A in ("%Logfile%") do ( set "lastline=%%A" )
set "lastline=%lastline: =%"

if defined lastline ( echo. >> "%Logfile%" )

echo. >> "%Logfile%"
echo [%date% %time%][%os%][%computername%][%username%]>> "%Logfile%"
echo.%Tab%>> "%Logfile%"
echo.  >> "%Logfile%"

echo Set WShell = CreateObject("WScript.Shell")           >> %VBS%
echo Set WshShell = WScript.CreateObject("WScript.Shell") >> %VBS%
echo WShell.Run("Notepad.exe %Logfile%")                  >> %VBS%
echo WScript.Sleep 1000                                   >> %VBS%
echo WshShell.AppActivate "Notepad"                       >> %VBS%
echo WshShell.AppActivate "Notepad"                       >> %VBS%
echo WshShell.AppActivate "Notepad"                       >> %VBS%
echo WshShell.SendKeys    "^{END}"                        >> %VBS%
echo WshShell.SendKeys    "^{END}"                        >> %VBS%
echo WshShell.SendKeys    "^{END}"                        >> %VBS%
echo WScript.Sleep 1                                      >> %VBS%
echo WshShell.SendKeys    "{LEFT}"                        >> %VBS%
echo WScript.Sleep 1                                      >> %VBS%
echo WshShell.SendKeys    "{LEFT}"                        >> %VBS%
echo WScript.Sleep 1                                      >> %VBS%
echo WshShell.SendKeys    "{DEL}"                         >> %VBS%
echo WScript.Sleep 1                                      >> %VBS%
echo WshShell.SendKeys    "{DEL}"                         >> %VBS%
echo WScript.Sleep 1                                      >> %VBS%
echo WshShell.SendKeys    "{LEFT}"                        >> %VBS%
echo WScript.Sleep 1                                      >> %VBS%
echo WshShell.SendKeys    "{LEFT}"                        >> %VBS%


timeout /t 1 >nul
start /wait %VBS%
timeout /t 1 >nul
if exist "%VBS%" del /q "%VBS%"
exit

:createmanual
    echo start "" "%~dp0%~nx0" >> "%Start%\Create_Log.bat"
    exit /b

:createonboot
    echo @mode 17,1                  >> "%Startup%\Create_Log_OnBoot.bat"
    echo timeout /t 20 /nobreak >nul >> "%Startup%\Create_Log_OnBoot.bat"
    echo start "" "%~dp0%~nx0"       >> "%Startup%\Create_Log_OnBoot.bat"
    exit /b

:Variables
    set       "Logfile=%~dp0Log_Entry.txt"
    set     "Lucidfile=%~dp0Lucid_Entry.txt"
    set      "Infofile=%~dp0Info.txt"
    set           "VBS=%~dp0x.vbs"
    set       "Startup=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
    set         "Start=%ProgramData%\Microsoft\Windows\Start Menu\Programs"
    set           "Tab=        "
    set           "Zip="%~dp07za.exe""
    set       "Archive=Entry_Archive.7z"

    set       "RawDate=%date%"
    set          "Year=%RawDate:~6,4%"
    set         "Month=%RawDate:~3,2%"
    set           "Day=%RawDate:~0,2%"
    set       "RawTime=%time%"
    set          "Hour=%RawTime:~0,2%"
    set        "Minute=%RawTime:~3,2%"
    set        "Second=%RawTime:~6,2%"
    set  "Milliseconds=%RawTime:~9,2%"
    set "FormattedTime=%Hour%-%Minute%-%Second%-%Milliseconds%"
    set "FormattedDate=%Year%-%Month%-%Day%"
    exit /b

goto start

