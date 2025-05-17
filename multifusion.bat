@echo off
setlocal enabledelayedexpansion

:: Change to the FaceFusion directory
cd /d "C:\Users\YourUsername\Documents\GitHub\facefusion"

:: Activate virtual environment
call venv\Scripts\activate

:: Delete temporary files and directories
set "FACEFUSION_DIR=%TEMP%\facefusion"
if exist "%FACEFUSION_DIR%" (
    del /q /s "%FACEFUSION_DIR%\*" >nul 2>&1
    echo Deleted contents of %FACEFUSION_DIR%
)
if exist "%TEMP%\gradio" (
    del /q /s "%TEMP%\gradio\*" >nul 2>&1
    echo Deleted contents of gradio
)

if exist run_log.txt del run_log.txt
set "SOURCE_TEMP_FILE=source_paths.txt"
if exist %SOURCE_TEMP_FILE% del %SOURCE_TEMP_FILE%
set "TARGET_TEMP_FILE=target_paths.txt"
if exist %TARGET_TEMP_FILE% del %TARGET_TEMP_FILE%

:: Create new log file
echo Log file created on %DATE% at %TIME% > run_log.txt
echo. >> run_log.txt

:: Define folders
set "batchDir=%cd%\"
set "source=%batchDir%source"
set "target=%batchDir%target"
set "OUTPUT_FOLDER=%batchDir%output"

:: Write source file paths
for %%f in ("%source%\*") do (
    if exist "%%f" (
        <nul set /p=%%f>> %SOURCE_TEMP_FILE%
        echo.>> %SOURCE_TEMP_FILE%
    )
)

:: Write target file paths
for %%f in ("%target%\*") do (
    if exist "%%f" (
        <nul set /p=%%f>> %TARGET_TEMP_FILE%
        echo.>> %TARGET_TEMP_FILE%
    )
)

:: Process combinations
for /f "usebackq delims=" %%s in ("%SOURCE_TEMP_FILE%") do (
    set "source_path=%%s"
    for %%a in ("%%~nxs") do set "source_filename=%%~na"
    for /f "usebackq delims=" %%t in ("%TARGET_TEMP_FILE%") do (
        set "target_path=%%t"
        for %%b in ("%%~nxt") do set "target_filename=%%~nb"
        set "output_file=%OUTPUT_FOLDER%\!source_filename!_!target_filename!.png"
        set "command=python facefusion.py headless-run -s "!source_path!" -t "!target_path!" -o "!output_file!""
        echo !command! >> run_log.txt
        echo !command!
        call !command!
    )
)

echo Facefusion has ended. Commands logged to run_log.txt
pause
endlocal
