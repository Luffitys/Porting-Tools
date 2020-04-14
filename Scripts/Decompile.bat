@echo off

	:: Required
set APKNAME=
	:: Enter "app" or "priv-app" Directory
set APP_OR_PRIV-APP=
	:: Enter "yes" or "no"
set NEEDS_MAGISK_MODULE=

set SYSTEM=ROM\ROM\system\system
set APKTOOL=Tools\APKTool
set APKPATH=%APP_OR_PRIV-APP%\%APKNAME%\%APKNAME%.apk

@echo on

cd ..

if /I "%NEEDS_MAGISK_MODULE%"=="yes" (robocopy Tools\Magisk_Template %APKNAME%_Magisk /e /NFL /NDL /NJH /NJS)

	:: Decompile APP
java -jar %APKTOOL%\apktool.jar d --no-debug-info --output %APKNAME%_APK %SYSTEM%\%APKPATH% -p %APKTOOL%\Frameworks

	:: Avoid cmd closing after finish to see eventual issues
pause
