@echo off

	:: Required
set APKNAME=
	:: Enter "app" or "priv-app" Directory
set APP_OR_PRIV-APP=
	:: Enter "yes" or "no"
set USES_MAGISK_MODULE=

set APKTOOL=Tools\APKTool
set ZIPNAME=%APKNAME%_Mod

if /I "%USES_MAGISK_MODULE%"=="yes" (set APKOUTPUT=%APKNAME%_Magisk\system\%APP_OR_PRIV-APP%\%APKNAME%) else (set APKOUTPUT=%APKNAME%_APK)


	:: Compile
cd ..
java -jar %APKTOOL%\apktool.jar b --no-crunch --output %APKOUTPUT%\%APKNAME%.apk %APKNAME%_APK  -p %APKTOOL%\Frameworks

	:: Zipalign
%APKTOOL%\zipalign.exe -f 4 %APKOUTPUT%\%APKNAME%.apk %APKOUTPUT%\%APKNAME%_zipaligned.apk

	:: Cleanup
del %APKOUTPUT%\%APKNAME%.*

	:: Sign
java -jar %APKTOOL%\ApkSigner.jar %APKTOOL%\Misc\PublicKey.pem %APKTOOL%\Misc\PrivateKey.pk8 %APKOUTPUT%\%APKNAME%_zipaligned.apk %APKOUTPUT%\%APKNAME%.apk

	:: Cleanup apk
del %APKOUTPUT%\%APKNAME%_zipaligned.apk

if /I "%USES_MAGISK_MODULE%"=="yes" (

	:: Cleanup zip
del %APKNAME%_Magisk\*.zip

	:: Compress --> zip
7z a %APKNAME%_Magisk\%ZIPNAME%.zip -xr!.git* -xr!LICENSE -r %APKNAME%_Magisk\* -mx9

	:: Push zip to phone
adb push %APKNAME%_Magisk\%ZIPNAME%.zip /sdcard/

)

	:: Avoid cmd closing after finish to see eventual issues
pause
