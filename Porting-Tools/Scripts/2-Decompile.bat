@echo off

set /p APKNAME="What's the APK's name?: "
set /p APKNAME_NEW="What should be the decompiled APK's name?: "
set /p PARTITION="What partition is the APK in? (system/system_ext/vendor/product): "
if /I "%PARTITION%"=="system" (
set PARTITION=system\system
)
set /p APP_OR_PRIV-APP="What folder is the APK in? (app/priv-app): "
set /p REQUIRES_MAGISK_MODULE="Is a Magisk Module for the modded APK required? (y/n): "

set ROM=ROM\ROM
set APKTOOL=Tools\APKTool

cd ..

if /I "%REQUIRES_MAGISK_MODULE%"=="y" (
robocopy Tools\Magisk_Template ..\%APKNAME_NEW%_Magisk /e /NFL /NDL /NJH /NJS
del ..\%APKNAME_NEW%_Magisk\.gitattributes ..\%APKNAME_NEW%_Magisk\.gitignore ..\%APKNAME_NEW%_Magisk\LICENSE ..\%APKNAME_NEW%_Magisk\system\placeholder
)

@echo on

	:: Decompile APP
java -jar %APKTOOL%\apktool.jar d --no-debug-info --keep-broken-res --output ..\%APKNAME_NEW%_APK %ROM%\%PARTITION%\%APP_OR_PRIV-APP%\%APKNAME%\%APKNAME%.apk -p %APKTOOL%\Frameworks

	:: Avoid cmd closing after finish to see eventual issues
pause
