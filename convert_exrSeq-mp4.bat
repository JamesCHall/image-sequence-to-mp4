@echo off

del /q "C:\ffmpeg\bin\images.txt"

set /p path=Image sequence path:
set /p framerate=Enter framerate:
cls

for %%a in ("%path%\*.exr") do (
    echo file 'file:%%a' >> "C:\ffmpeg\bin\images.txt"
)

C:\ffmpeg\bin\ffmpeg.exe -apply_trc iec61966_2_1 -r %framerate% -f concat -safe 0 -i "C:\ffmpeg\bin\images.txt" -c:v libx264 -pix_fmt yuv420p "%path%\output.mp4"

pause

del /q "C:\ffmpeg\bin\images.txt"