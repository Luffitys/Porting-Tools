@echo off

set /p APKNAME="What's the APK name?: "
set /p APKNAME_NEW="What should be the new APK name?: "
set /p APP_OR_PRIV-APP="What folder? (app/priv-app): "
set /p NEEDS_MAGISK_MODULE="Magisk Module required? (y/n): "
set /p DECOMPILE_APK_RESOURCES="Decompile APK Resources? (y/n): "

set SYSTEM=ROM\ROM\system\system
set APKTOOL=Tools\APKTool
set APKPATH=%APP_OR_PRIV-APP%\%APKNAME%\%APKNAME%.apk

cd ..

if /I "%NEEDS_MAGISK_MODULE%"=="y" (robocopy Tools\Magisk_Template ..\%APKNAME_NEW%_Magisk /e /NFL /NDL /NJH /NJS)

@echo on

	:: Decompile APP
if /I "%DECOMPILE_APK_RESOURCES%"=="y" (java -jar %APKTOOL%\apktool.jar d --no-debug-info --output ..\%APKNAME_NEW%_APK %SYSTEM%\%APKPATH% -p %APKTOOL%\Frameworks) else (java -jar %APKTOOL%\apktool.jar d --no-debug-info --no-res --output ..\%APKNAME_NEW%_APK %SYSTEM%\%APKPATH% -p %APKTOOL%\Frameworks)

	:: Avoid cmd closing after finish to see eventual issues
pause
