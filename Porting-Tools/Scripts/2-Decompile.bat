@echo off

set /p APKNAME="What's the APK's name?: "
set /p APKNAME_NEW="What should be the decompiled APK's name?: "
set /p APP_OR_PRIV-APP="What folder is the APK in? (app/priv-app): "
set /p REQUIRES_MAGISK_MODULE="Is a Magisk Module for the modded APK required? (y/n): "

set SYSTEM=ROM\ROM\system\system
set APKTOOL=Tools\APKTool
set APKPATH=%APP_OR_PRIV-APP%\%APKNAME%\%APKNAME%.apk

cd ..

if /I "%REQUIRES_MAGISK_MODULE%"=="y" (robocopy Tools\Magisk_Template ..\%APKNAME_NEW%_Magisk /e /NFL /NDL /NJH /NJS)

@echo on

	:: Decompile APP
java -jar %APKTOOL%\apktool.jar d -b --output ..\%APKNAME_NEW%_APK %SYSTEM%\%APKPATH% -p %APKTOOL%\Frameworks

	:: Avoid cmd closing after finish to see eventual issues
pause
