@echo off


	:: Required
set APKNAME=
	:: Enter "app" or "priv-app" Directory (Only if using Magisk Module)
set APP_OR_PRIV-APP=
	:: Enter "y" or leave blank
set USES_MAGISK_MODULE=


set APKTOOL=Tools\APKTool
set ZIPNAME=%APKNAME%_Mod
set ZIP=Tools\7z\7z.exe
set ADB=Tools\adb\adb.exe


@echo on


cd ..

if /I "%USES_MAGISK_MODULE%"=="y" (set APKOUTPUT=..\%APKNAME%_Magisk\system\%APP_OR_PRIV-APP%\%APKNAME%) else (set APKOUTPUT=..\%APKNAME%_APK)


	:: Compile
java -jar %APKTOOL%\apktool.jar b --no-crunch --output %APKOUTPUT%\%APKNAME%.apk ..\%APKNAME%_APK  -p %APKTOOL%\Frameworks

	:: Zipalign
%APKTOOL%\zipalign.exe -f 4 %APKOUTPUT%\%APKNAME%.apk %APKOUTPUT%\%APKNAME%_zipaligned.apk

	:: Cleanup
del %APKOUTPUT%\%APKNAME%.*

	:: Sign
java -jar %APKTOOL%\ApkSigner.jar %APKTOOL%\Misc\PublicKey.pem %APKTOOL%\Misc\PrivateKey.pk8 %APKOUTPUT%\%APKNAME%_zipaligned.apk %APKOUTPUT%\%APKNAME%.apk

	:: Cleanup apk
del %APKOUTPUT%\%APKNAME%_zipaligned.apk

if /I "%USES_MAGISK_MODULE%"=="y" (

	:: Cleanup zip
del ..\%APKNAME%_Magisk\*.zip

	:: Compress --> zip
%ZIP% a ..\%APKNAME%_Magisk\%ZIPNAME%.zip -xr!.git* -xr!LICENSE -r ..\%APKNAME%_Magisk\* -mx9

	:: Push zip to phone
%ADB% push ..\%APKNAME%_Magisk\%ZIPNAME%.zip /sdcard/

)

	:: Avoid cmd closing after finish to see eventual issues
pause
