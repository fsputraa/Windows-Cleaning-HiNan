@echo off

setlocal ENABLEDELAYEDEXPANSION

title HiNan TOOLS - CleanUp
color 0A
mode con: cols=54 lines=42

:: ---------- TIME ----------
set "STARTTIME=%TIME%"
set /a COUNT=0

:: ---------- CEK ADMIN ----------
net session >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo ======================================================
    echo        HARUS DIJALANKAN SEBAGAI ADMIN
    echo ======================================================
    echo.
    pause
    exit /b 1
)
color 0A

:: ---------- HEADER ----------
echo.
echo ======================================================
echo.
echo         HH   HH  III  NN   NN   AA   NN   NN
echo         HH   HH  III  NNN  NN  A  A  NNN  NN
echo         HHHHHHH  III  NN N NN AAAAAA NN N NN
echo         HH   HH  III  NN  NNN A    A NN  NNN
echo         HH   HH  III  NN   NN A    A NN   NN
echo.
echo               HiNan TOOLS by Fernando
echo.
echo ======================================================
echo.
color 07
echo                CLEANING YOUR WINDOWS....
echo          Started : %DATE% %TIME%
color 0A
echo.
echo ======================================================
echo.

:: ================= STEP 1 =================
<nul set /p =" [1/9] TEMP User............... "
timeout /t 1 >nul
del /f /s /q "%TEMP%\*" >nul 2>&1
for /d %%D in ("%TEMP%\*") do rd /s /q "%%D" >nul 2>&1
echo [OK]
set /a COUNT+=1

:: ================= STEP 2 =================
<nul set /p =" [2/9] Windows Temp............ "
timeout /t 1 >nul
del /f /s /q "C:\Windows\Temp\*" >nul 2>&1
for /d %%D in ("C:\Windows\Temp\*") do rd /s /q "%%D" >nul 2>&1
echo [OK]
set /a COUNT+=1

:: ================= STEP 3 =================
<nul set /p =" [3/9] Windows Update Cache.... "
timeout /t 1 >nul
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
del /f /s /q "C:\Windows\SoftwareDistribution\Download\*" >nul 2>&1
net start bits >nul 2>&1
net start wuauserv >nul 2>&1
echo [OK]
set /a COUNT+=1

:: ================= STEP 4 =================
<nul set /p =" [4/9] Thumbnail Cache......... "
timeout /t 1 >nul
del /f /q "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1
echo [OK]
set /a COUNT+=1

:: ================= STEP 5 =================
<nul set /p =" [5/9] Flush DNS............... "
timeout /t 1 >nul
ipconfig /flushdns >nul 2>&1
echo [OK]
set /a COUNT+=1

:: ================= STEP 6 =================
<nul set /p =" [6/9] Prefetch................ "
timeout /t 1 >nul
del /f /s /q "C:\Windows\Prefetch\*" >nul 2>&1
echo [OK]
set /a COUNT+=1

:: ================= STEP 7 =================
<nul set /p =" [7/9] Recent Files............ "
timeout /t 1 >nul
del /f /s /q "%APPDATA%\Microsoft\Windows\Recent\*" >nul 2>&1
echo [OK]
set /a COUNT+=1

:: ================= STEP 8 =================
<nul set /p =" [8/9] Shader Cache............ "
timeout /t 1 >nul
del /f /s /q "%LocalAppData%\D3DSCache\*" >nul 2>&1
echo [OK]
set /a COUNT+=1

:: ================= STEP 9 =================
<nul set /p =" [9/9] Recycle Bin............. "
timeout /t 1 >nul
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
echo [OK]
set /a COUNT+=1

:: ---------- DONE ----------
set "ENDTIME=%TIME%"

echo.
echo ======================================================
echo.
echo            PROSES - 100%%
echo.
echo ======================================================
echo.
color 07
echo      Total Step : %COUNT% / 9 DONE
echo      Started    : %STARTTIME%
echo      Finished   : %DATE% %ENDTIME%
color 0A
echo.
echo ======================================================
echo.

pause
endlocal
exit /b 0