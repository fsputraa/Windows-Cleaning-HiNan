@echo off
chcp 65001 >nul
setlocal EnableExtensions EnableDelayedExpansion
 
:: =====================================================
::  HiNan TOOLS - Windows Cleaner  v3.0
::  by Fernando
:: =====================================================

:: ---------- SETTINGS (1 = on, 0 = off) ----------
set "CLEAN_BROWSERS=1"
set "CLEAR_EVENTLOGS=1"
set "RUN_DISM=1"
set "RUN_TRIM=1"

:: ---------- RELAUNCH: classic console host + Administrator ----------
if /i not "%~1"=="HNCHILD" (
    set "HN_SELF=%~f0"
    powershell -NoProfile -ExecutionPolicy Bypass -Command "$a='cmd.exe /c ' + [char]34 + $env:HN_SELF + [char]34 + ' HNCHILD'; Start-Process -FilePath conhost.exe -ArgumentList $a -Verb RunAs" >nul 2>&1
    if errorlevel 1 (
        echo.
        echo  Administrator permission is required. Please accept the UAC prompt.
        echo.
        pause
    )
    exit /b
)

:: ---------- WINDOW SETUP ----------
set "SELF=%~f0"
title HiNan TOOLS - Windows Cleaner
color 0F
mode con: cols=82 lines=28

net session >nul 2>&1
if errorlevel 1 (
    color 0C
    echo.
    echo  Administrator rights are required.
    echo.
    pause
    exit /b 1
)

:: lock minimize / maximize / close buttons + disable QuickEdit
powershell -NoProfile -ExecutionPolicy Bypass -Command "$t=[IO.File]::ReadAllText($env:SELF,[Text.Encoding]::UTF8);$i=$t.LastIndexOf('#PS'+'_BEGIN');Invoke-Expression $t.Substring($i+9)" >nul 2>&1

:: ---------- COLORS (ANSI) ----------
for /f "delims=#" %%E in ('"prompt #$E# & for %%E in (1) do rem"') do set "ESC=%%E"
set "C0=%ESC%[0m"
set "FR=%ESC%[38;2;70;90;135m"
set "CY=%ESC%[38;2;0;220;255m"
set "VI=%ESC%[38;2;170;120;255m"
set "GR=%ESC%[38;2;70;255;140m"
set "YE=%ESC%[38;2;255;210;70m"
set "GY=%ESC%[38;2;115;120;140m"
set "WH=%ESC%[1;38;2;255;255;255m"
set "LW=%ESC%[38;2;200;205;220m"
set "LG1=%ESC%[38;2;0;225;255m"
set "LG2=%ESC%[38;2;40;195;255m"
set "LG3=%ESC%[38;2;90;160;255m"
set "LG4=%ESC%[38;2;140;130;255m"
set "LG5=%ESC%[38;2;195;100;255m"
set "SP=                                                                          "

:: ---------- STEP NAMES ----------
set "L1=User Temp Files"
set "L2=Windows Temp Files"
set "L3=Windows Update Cache"
set "L4=Delivery Optimization"
set "L5=Thumbnail and Icon Cache"
set "L6=Prefetch Files"
set "L7=Recent Files and Lists"
set "L8=GPU Shader Cache"
set "L9=Browser Cache"
set "L10=Application Cache"
set "L11=Crash Dumps and Reports"
set "L12=System and Event Logs"
set "L13=DNS and Clipboard"
set "L14=Recycle Bin"
set "L15=Component Store (DISM)"
set "L16=Drive TRIM Optimize"

set "TOTAL=16"
set "CUR=0"
set "DRV=%SystemDrive:~0,1%"
set "LOG=%USERPROFILE%\HiNan-CleanLog.txt"
set "STARTTIME=%TIME%"
call :GETFREE FREE_BEFORE
echo [%DATE% %TIME%] ===== HiNan Cleaner started ===== >> "%LOG%"

:: ---------- DRAW INTERFACE ----------
cls
<nul set /p "=%ESC%[?25l"
set "HL="
for /l %%i in (1,1,78) do set "HL=!HL!═"

for /l %%r in (2,1,24) do (
    call :AT %%r 1 "!FR!║!C0!"
    call :AT %%r 80 "!FR!║!C0!"
)
call :AT 1 1 "!FR!╔!HL!╗!C0!"
call :AT 10 1 "!FR!╠!HL!╣!C0!"
call :AT 12 1 "!FR!╠!HL!╣!C0!"
call :AT 21 1 "!FR!╠!HL!╣!C0!"
call :AT 25 1 "!FR!╚!HL!╝!C0!"
for /l %%r in (13,1,20) do call :AT %%r 40 "!FR!│!C0!"

call :AT 3 25 "!LG1!█   █  ███  █   █   ███   █   █!C0!"
call :AT 4 25 "!LG2!█   █   █   ██  █  █   █  ██  █!C0!"
call :AT 5 25 "!LG3!█████   █   █ █ █  █████  █ █ █!C0!"
call :AT 6 25 "!LG4!█   █   █   █  ██  █   █  █  ██!C0!"
call :AT 7 25 "!LG5!█   █  ███  █   █  █   █  █   █!C0!"
call :AT 8 26 "!WH!W I N D O W S   C L E A N E R!C0!"
call :AT 9 23 "!GY!HiNan TOOLS!C0!  !VI!·!C0!  !GY!v3.0!C0!  !VI!·!C0!  !GY!by Fernando!C0!"

call :AT 11 4 "!CY!♦!C0! !GY!Drive!C0! !WH!%SystemDrive%!C0!      !CY!♦!C0! !GY!Free space!C0! !WH!!FREE_BEFORE_TXT!!C0!      !CY!♦!C0! !GY!Started!C0! !WH!%TIME:~0,8%!C0!"

for /l %%n in (1,1,16) do call :CELL %%n P
call :BAR 0
call :AT 24 4 "!VI!♦!C0! !GY!Please wait. This window closes automatically when finished.!C0!"

:: ================= 1 =================
call :BEGIN
call :PURGE "%TEMP%"
call :PURGE "%LocalAppData%\Temp"
call :DONE

:: ================= 2 =================
call :BEGIN
call :PURGE "%SystemRoot%\Temp"
call :DONE

:: ================= 3 =================
call :BEGIN
net stop wuauserv /y >nul 2>&1
net stop bits /y >nul 2>&1
net stop dosvc /y >nul 2>&1
call :PURGE "%SystemRoot%\SoftwareDistribution\Download"
call :DONE

:: ================= 4 =================
call :BEGIN
call :PURGE "%SystemRoot%\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache"
net start bits >nul 2>&1
net start wuauserv >nul 2>&1
call :DONE

:: ================= 5 =================
call :BEGIN
del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\iconcache_*.db" >nul 2>&1
call :PURGE "%LocalAppData%\Microsoft\Windows\INetCache"
call :DONE

:: ================= 6 =================
call :BEGIN
call :PURGE "%SystemRoot%\Prefetch"
call :DONE

:: ================= 7 =================
call :BEGIN
call :PURGE "%AppData%\Microsoft\Windows\Recent"
call :DONE

:: ================= 8 =================
call :BEGIN
call :PURGE "%LocalAppData%\D3DSCache"
call :PURGE "%LocalAppData%\NVIDIA\DXCache"
call :PURGE "%LocalAppData%\NVIDIA\GLCache"
call :PURGE "%LocalAppData%\AMD\DxCache"
call :PURGE "%LocalAppData%\AMD\GLCache"
call :PURGE "%LocalAppData%\Intel\ShaderCache"
call :DONE

:: ================= 9 =================
call :BEGIN
if "%CLEAN_BROWSERS%"=="1" (
    call :CHROMIUM "%LocalAppData%\Google\Chrome\User Data"
    call :CHROMIUM "%LocalAppData%\Microsoft\Edge\User Data"
    call :CHROMIUM "%LocalAppData%\BraveSoftware\Brave-Browser\User Data"
    call :CHROMIUM "%LocalAppData%\Vivaldi\User Data"
    call :PURGE "%LocalAppData%\Opera Software\Opera Stable\Cache"
    call :PURGE "%LocalAppData%\Opera Software\Opera GX Stable\Cache"
    for /d %%P in ("%LocalAppData%\Mozilla\Firefox\Profiles\*") do (
        call :PURGE "%%~P\cache2"
        call :PURGE "%%~P\startupCache"
    )
    call :DONE
) else (
    call :SKIP
)

:: ================= 10 =================
call :BEGIN
call :PURGE "%AppData%\discord\Cache"
call :PURGE "%AppData%\discord\Code Cache"
call :PURGE "%AppData%\discord\GPUCache"
call :PURGE "%LocalAppData%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalCache"
call :PURGE "%LocalAppData%\Microsoft\Windows\Caches"
call :DONE

:: ================= 11 =================
call :BEGIN
call :PURGE "%SystemRoot%\Minidump"
call :PURGE "%LocalAppData%\CrashDumps"
call :PURGE "%LocalAppData%\Microsoft\Windows\WER"
call :PURGE "%ProgramData%\Microsoft\Windows\WER\ReportArchive"
call :PURGE "%ProgramData%\Microsoft\Windows\WER\ReportQueue"
call :PURGE "%ProgramData%\Microsoft\Windows\WER\Temp"
call :PURGE "%SystemRoot%\LiveKernelReports"
del /f /q "%SystemRoot%\MEMORY.DMP" >nul 2>&1
call :DONE

:: ================= 12 =================
call :BEGIN
del /f /q "%SystemRoot%\Logs\CBS\*.log" >nul 2>&1
del /f /q "%SystemRoot%\Logs\DISM\*.log" >nul 2>&1
del /f /q "%SystemRoot%\Logs\WindowsUpdate\*.etl" >nul 2>&1
if "%CLEAR_EVENTLOGS%"=="1" (
    for /f "delims=" %%L in ('wevtutil el 2^>nul') do wevtutil cl "%%L" >nul 2>&1
)
call :DONE

:: ================= 13 =================
call :BEGIN
ipconfig /flushdns >nul 2>&1
cmd /c "echo off | clip" >nul 2>&1
call :DONE

:: ================= 14 =================
call :BEGIN
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
if exist "%SystemDrive%\$Recycle.Bin" rd /s /q "%SystemDrive%\$Recycle.Bin" >nul 2>&1
call :DONE

:: ================= 15 (5 minute time limit) =================
call :BEGIN
if "%RUN_DISM%"=="1" (
    powershell -NoProfile -Command "$p=Start-Process dism.exe -ArgumentList '/Online','/Cleanup-Image','/StartComponentCleanup','/NoRestart' -WindowStyle Hidden -PassThru; if(-not $p.WaitForExit(300000)){try{$p.Kill()}catch{}}" >nul 2>&1
    call :DONE
) else (
    call :SKIP
)

:: ================= 16 (2 minute time limit) =================
call :BEGIN
if "%RUN_TRIM%"=="1" (
    powershell -NoProfile -Command "$p=Start-Process defrag.exe -ArgumentList '%SystemDrive%','/L' -WindowStyle Hidden -PassThru; if(-not $p.WaitForExit(120000)){try{$p.Kill()}catch{}}" >nul 2>&1
    call :DONE
) else (
    call :SKIP
)

:: ---------- RESULTS ----------
set "ENDTIME=%TIME%"
call :GETFREE FREE_AFTER
call :TOSEC "%STARTTIME%" S1
call :TOSEC "%ENDTIME%" S2
set /a EL=S2-S1
if !EL! lss 0 set /a EL+=86400
set /a EM=EL/60, ES=EL%%60
set "EM=0!EM!"
set "EM=!EM:~-2!"
set "ES=0!ES!"
set "ES=!ES:~-2!"

set "FREED=0 MB"
for /f "tokens=*" %%A in ('powershell -NoProfile -Command "$a=!FREE_AFTER!;$b=!FREE_BEFORE!;$m=[math]::Max(0,[int](($a-$b)/1MB));if($m -ge 1024){('{0:N2} GB' -f ($m/1024))}else{('{0} MB' -f $m)}" 2^>nul') do set "FREED=%%A"

title HiNan TOOLS - Completed
echo [%DATE% %ENDTIME%] ===== Completed. Freed: !FREED! ===== >> "%LOG%"
call :BAR 100
call :CLR 23
call :AT 23 4 "!GR!√!C0!  !WH!All tasks completed!C0!   !GY!·!C0!   !GY!Freed!C0! !GR!!FREED!!C0!   !GY!·!C0!   !GY!Free now!C0! !WH!!FREE_AFTER_TXT!!C0!"

for /l %%s in (8,-1,1) do (
    call :CLR 24
    call :AT 24 4 "!VI!♦!C0! !GY!Elapsed!C0! !WH!!EM!:!ES!!C0!   !GY!·   Window closes in!C0! !YE!%%s!C0! !GY!sec!C0!"
    ping -n 2 127.0.0.1 >nul
)
<nul set /p "=%ESC%[28;1H%ESC%[?25h"
exit 0


:: =====================================================
::  SUBROUTINES
:: =====================================================

:AT
<nul set /p "=%ESC%[%~1;%~2H%~3"
exit /b

:CLR
<nul set /p "=%ESC%[%~1;4H%SP%"
exit /b

:CELL
set /a "R=13+((%~1-1) %% 8)"
if %~1 gtr 8 (set "CC=43") else (set "CC=4")
set "NUM=0%~1"
set "NUM=!NUM:~-2!"
set "T=!L%~1!                                        "
set "T=!T:~0,30!"
if "%~2"=="P" (set "IC=!GY!○" & set "TC=!GY!")
if "%~2"=="R" (set "IC=!YE!►" & set "TC=!WH!")
if "%~2"=="D" (set "IC=!GR!√" & set "TC=!LW!")
if "%~2"=="S" (set "IC=!GY!–" & set "TC=!GY!")
<nul set /p "=%ESC%[!R!;!CC!H!IC!!C0! !GY!!NUM!!C0! !TC!!T!!C0!"
exit /b

:BAR
set /a "FL=%~1*50/100"
set "B1=" & set "B2="
for /l %%g in (0,1,9) do (
    set /a "RR=%%g*19, GG=220-%%g*11"
    for /l %%k in (1,1,5) do (
        set /a "IX=%%g*5+%%k"
        if !IX! leq !FL! (
            if %%k==1 set "B1=!B1!%ESC%[38;2;!RR!;!GG!;255m"
            set "B1=!B1!█"
        ) else (
            set "B2=!B2!░"
        )
    )
)
set "P=   %~1"
set "P=!P:~-3!"
<nul set /p "=%ESC%[22;4H!B1!!FR!!B2!!C0!  !WH!!P!%%!C0!"
exit /b

:BEGIN
set /a CUR+=1
set "LBL=!L%CUR%!"
call :CELL !CUR! R
call :CLR 23
<nul set /p "=%ESC%[23;4H!YE!►!C0!  !GY!Cleaning!C0!  !WH!!LBL!!C0!"
exit /b

:DONE
set /a "PCT=CUR*100/TOTAL"
call :CELL !CUR! D
call :BAR !PCT!
title HiNan TOOLS - Cleaning !PCT!%%
echo [%DATE% %TIME%] OK   - !LBL! >> "%LOG%"
exit /b

:SKIP
set /a "PCT=CUR*100/TOTAL"
call :CELL !CUR! S
call :BAR !PCT!
echo [%DATE% %TIME%] SKIP - !LBL! >> "%LOG%"
exit /b

:PURGE
if "%~1"=="" exit /b
if not exist "%~1\" exit /b
del /f /s /q "%~1\*" >nul 2>&1
for /d %%D in ("%~1\*") do rd /s /q "%%D" >nul 2>&1
exit /b

:CHROMIUM
if not exist "%~1\" exit /b
for /d %%P in ("%~1\*") do (
    for %%C in ("Cache" "Code Cache" "GPUCache" "DawnCache" "Service Worker\CacheStorage") do call :PURGE "%%~P\%%~C"
)
call :PURGE "%~1\GrShaderCache"
call :PURGE "%~1\ShaderCache"
exit /b

:GETFREE
set "%~1=0"
set "%~1_TXT=N/A"
for /f "tokens=1,2 delims=;" %%A in ('powershell -NoProfile -Command "$f=(Get-PSDrive -Name %DRV%).Free; '{0};{1:N2} GB' -f $f,($f/1GB)" 2^>nul') do (
    set "%~1=%%A"
    set "%~1_TXT=%%B"
)
exit /b

:TOSEC
for /f "tokens=1-3 delims=:.,  " %%a in ("%~1") do (
    set /a "%~2=((100%%a) %% 100)*3600+((100%%b) %% 100)*60+((100%%c) %% 100)"
)
exit /b

#PS_BEGIN
Add-Type -Namespace HN -Name Win -MemberDefinition @'
[DllImport("kernel32.dll")] public static extern IntPtr GetConsoleWindow();
[DllImport("kernel32.dll")] public static extern IntPtr GetStdHandle(int n);
[DllImport("kernel32.dll")] public static extern bool GetConsoleMode(IntPtr h, out uint m);
[DllImport("kernel32.dll")] public static extern bool SetConsoleMode(IntPtr h, uint m);
[DllImport("user32.dll")] public static extern IntPtr GetSystemMenu(IntPtr h, bool r);
[DllImport("user32.dll")] public static extern bool DeleteMenu(IntPtr m, uint p, uint f);
[DllImport("user32.dll")] public static extern int GetWindowLong(IntPtr h, int i);
[DllImport("user32.dll")] public static extern int SetWindowLong(IntPtr h, int i, int v);
[DllImport("user32.dll")] public static extern bool DrawMenuBar(IntPtr h);
'@
$h = [HN.Win]::GetConsoleWindow()
if ($h -ne [IntPtr]::Zero) {
  $m = [HN.Win]::GetSystemMenu($h, $false)
  foreach ($c in 0xF060, 0xF030, 0xF020, 0xF000, 0xF120) { [void][HN.Win]::DeleteMenu($m, [uint32]$c, 0) }
  $s = [HN.Win]::GetWindowLong($h, -16)
  $s = $s -band (-bnot 0x70000)
  [void][HN.Win]::SetWindowLong($h, -16, $s)
  [void][HN.Win]::DrawMenuBar($h)
}
$i = [HN.Win]::GetStdHandle(-10)
$mode = [uint32]0
if ([HN.Win]::GetConsoleMode($i, [ref]$mode)) {
  $mode = [uint32](($mode -band 4294967231) -bor 128)
  [void][HN.Win]::SetConsoleMode($i, $mode)
}
 
