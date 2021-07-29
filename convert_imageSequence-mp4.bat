@echo off

cls

set exr_param=

set /p filepath=Image sequence path:
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

if exist "%filepath%\images.txt" (
    del /q "%filepath%\images.txt"
)
for %%a in ("%filepath%\*.%filetype%") do (
    echo file 'file:%%a' >> "%filepath%\images.txt"
)

ffmpeg\bin\ffmpeg.exe %exr_param% -r %framerate% -f concat -safe 0 -i "%filepath%\images.txt" -c:v libx264 -pix_fmt yuv420p "%filepath%\output.mp4"

del /q "%filepath%\images.txt"