@echo off

set INPUTDIR=input
set /p FILEPATH="What is the apk's filename? (example: MiuiCamera.apk): "
set /p FILENAME_NEW="What should be the decompiled file's foldername? (example: MiuiCamera): "
set /p REQUIRES_MAGISK_MODULE="Is a Magisk Module for the decompiled apk required? (y/n): "
set /p APKTOOL_DEX="Should the file's .dex file(s) be decompiled? (y/n): "
set /p APKTOOL_RESOURCES="Should the file's .arsc file be decompiled? (y/n): "

set APKTOOL=Tools\APKTool

set APKTOOL_DEX=
if /I "%APKTOOL_DEX%"=="n" (
	set APKTOOL_DEX=--no-src
)

set APKTOOL_RES=
if /I "%APKTOOL_RES%"=="n" (
	set APKTOOL_RES=--no-res
)

cd ..

if /I "%REQUIRES_MAGISK_MODULE%"=="y" (
	robocopy "Tools\Magisk_MMT_Template" "out\%FILENAME_NEW%_Magisk" /e /NFL /NDL /NJH /NJS
)

if not exist "out" (
	md "out"
)

java -jar "%APKTOOL%\apktool.jar" d %APKTOOL_DEX% %APKTOOL_RES% --keep-broken-res --output "out\%FILENAME_NEW%" "%INPUTDIR%\%FILEPATH%"

pause
