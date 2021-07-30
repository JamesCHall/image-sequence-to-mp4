@echo off
SETLOCAL EnableDelayedExpansion
cls

set exr_param=
set files=

IF "%filepath%"=="" (
    set /p filepath="Image sequence path:"
) else (
    set /p filepath="Image sequence path (%filepath%):"
)
set /p framerate=Enter framerate (25): || set framerate=25
choice /N /C:pje /M "Is this sequence (P)NG, (J)PG or (E)XR:"%1

IF ERRORLEVEL ==1 (
    set filetype=png    
)
IF ERRORLEVEL ==2 (
    set filetype=jpg
)
IF ERRORLEVEL ==3 (
    set filetype=exr
    set exr_param="-apply_trc iec61966_2_1 "
)
cls

if exist "%temp%\convert_image_sequence_file_list.txt" (
    del /q "%temp%\convert_image_sequence_file_list.txt"
)
for %%a in ("%filepath%\*.%filetype%") do (
    echo file 'file:%%a' >> "%temp%\convert_image_sequence_file_list.txt"
)

ffmpeg\bin\ffmpeg.exe %exr_param% -r %framerate% -f concat -safe 0 -i "%temp%\convert_image_sequence_file_list.txt" -c:v libx264 -pix_fmt yuv420p "%filepath%\output.mp4"

if exist "%temp%\convert_image_sequence_file_list.txt" (
    del /q "%temp%\convert_image_sequence_file_list.txt"
)