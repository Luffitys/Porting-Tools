@echo off

	:: Required, without _APK suffix
set APKNAME=
	:: If using Magisk module, enter "app" or "priv-app" directory, otherwise leave blank
set APP_OR_PRIV-APP=
	:: Enter "y" or leave blank
set USES_MAGISK_MODULE=
	:: Enter "n" or leave blank
set ARE_RESOURCES_DECOMPILED=
	:: Enter "y" or leave blank
set COPY_ORIGINAL_MANIFEST=

set APKTOOL=Tools\APKTool
set ZIPNAME=%APKNAME%_Mod
set ZIP=Tools\7z\7z.exe
set ADB=Tools\adb\adb.exe

@echo on

cd ..

if /I "%USES_MAGISK_MODULE%"=="y" (set APKOUTPUT=..\%APKNAME%_Magisk\system\%APP_OR_PRIV-APP%\%APKNAME%) else (set APKOUTPUT=..\%APKNAME%_APK)

	:: Compile
if /I "%COPY_ORIGINAL_MANIFEST%"=="y" (set COPY_ORIGINAL_MANIFEST=-c)
java -jar %APKTOOL%\apktool.jar b %COPY_ORIGINAL_MANIFEST% --no-crunch --output %APKOUTPUT%\%APKNAME%_.apk ..\%APKNAME%_APK  -p %APKTOOL%\Frameworks

	:: Zipalign
%APKTOOL%\zipalign.exe -f 4 %APKOUTPUT%\%APKNAME%_.apk %APKOUTPUT%\%APKNAME%.apk

	:: Sign
if /I "%ARE_RESOURCES_DECOMPILED%"==!"n" (java -jar %APKTOOL%\ApkSigner.jar sign --key %APKTOOL%\Misc\PrivateKey.pk8 --cert %APKTOOL%\Misc\PublicKey.pem %APKOUTPUT%\%APKNAME%.apk)

	:: Cleanup
del %APKOUTPUT%\%APKNAME%_.apk
del %APKOUTPUT%\%APKNAME%.apk.idsig
del %APKOUTPUT%\%APKNAME%.jobf

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
