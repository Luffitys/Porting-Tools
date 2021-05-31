@echo off

set /p INPUTDIR="Is the file in the ROM or the input folder? (ROM/input): "
if /I "%INPUTDIR%"=="input" (
	set INPUTDIR=input
	set /p FILEPATH="What is the file's name? (example: services.jar): "
) else (
	set INPUTDIR=ROM\ROM
	set /p FILEPATH="What is the path to the file? (example: system\system\framework\services.jar): "
)
set /p FILENAME_NEW="What should be the decompiled file's name, without extension, be? (example: MiuiCameraMOD): "
set /p REQUIRES_MAGISK_MODULE="Is a Magisk Module for the decompiled file required? (y/n): "
set /p APKTOOL_DEX="Should the file's .dex file(s) be decompiled? (y/n): "
set /p APKTOOL_RESOURCES="Should the file's .arsc file be decompiled? (y/n): "

set APKTOOL=Tools\APKTool

if /I "%APKTOOL_DEX%"=="n" (
	set APKTOOL_DEX=--no-src
) else (
	set APKTOOL_DEX=
)

if /I "%APKTOOL_RESOURCES%"=="n" (
	set APKTOOL_RESOURCES=--no-res
) else (
	set APKTOOL_RESOURCES=
)

cd ..

if /I "%REQUIRES_MAGISK_MODULE%"=="y" (
	robocopy Tools\Magisk_Template ..\%FILENAME_NEW%_Magisk /e /NFL /NDL /NJH /NJS
	del ..\%FILENAME_NEW%_Magisk\.gitattributes ..\%FILENAME_NEW%_Magisk\.gitignore ..\%FILENAME_NEW%_Magisk\LICENSE ..\%FILENAME_NEW%_Magisk\system\placeholder
)

@echo on

	:: Decompile APP
java -jar %APKTOOL%\apktool.jar d %APKTOOL_DEX% %APKTOOL_RESOURCES% --no-debug-info --keep-broken-res --output ..\%FILENAME_NEW%_DECOMPILED %INPUTDIR%\%FILEPATH% -p %APKTOOL%\Frameworks

	:: Avoid closing the CMD to see potential issues
pause
