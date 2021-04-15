@echo off

	:: Enter the APK Name without the "_APK" directory suffix
set APKNAME=
	:: If a Magisk Module is required, enter "y", otherwise leave blank
set REQUIRES_MAGISK_MODULE=
	:: If using Magisk module, enter the partition name the APK should be in
set PARTITION=
	:: If using Magisk module, enter "app" or "priv-app" depending on the APK's directory, otherwise leave blank
set APP_OR_PRIV-APP=
	:: If the original manifest should be used, enter "y", otherwise leave blank
set COPY_ORIGINAL_MANIFEST=
	:: If the APK should be compiled with AAPT2, enter "y", otherwise leave blank
set COMPILE_WITH_AAPT2=
	:: If using Magisk module, enter a value ranging from 0-9, 0 being the lowest and 9 the highest compression level
set ZIP_COMPRESSION_LEVEL=

set APKTOOL=Tools\APKTool
set ZIPNAME=%APKNAME%_Mod
set ZIP=Tools\7z\7z.exe
set ADB=Tools\adb\adb.exe

if /I "%COPY_ORIGINAL_MANIFEST%"=="y" (
set COPY_ORIGINAL_MANIFEST=-c
)

if /I "%COMPILE_WITH_AAPT2%"=="y" (
set COMPILE_WITH_AAPT2=--use-aapt2
)

if /I "%REQUIRES_MAGISK_MODULE%"=="y" (
set APKOUTPUT=..\%APKNAME%_Magisk\%PARTITION%\%APP_OR_PRIV-APP%\%APKNAME%
) else (
set APKOUTPUT=..\%APKNAME%_APK
)

@echo on

cd ..

	:: Compile
java -jar %APKTOOL%\apktool.jar b --no-crunch %COMPILE_WITH_AAPT2% %COPY_ORIGINAL_MANIFEST% --output %APKOUTPUT%\%APKNAME%_.apk ..\%APKNAME%_APK  -p %APKTOOL%\Frameworks

	:: Zipalign
%APKTOOL%\zipalign.exe -f 4 %APKOUTPUT%\%APKNAME%_.apk %APKOUTPUT%\%APKNAME%.apk

	:: Sign
java -jar %APKTOOL%\ApkSigner.jar sign --key %APKTOOL%\Misc\PrivateKey.pk8 --cert %APKTOOL%\Misc\PublicKey.pem %APKOUTPUT%\%APKNAME%.apk

	:: Cleanup
del %APKOUTPUT%\%APKNAME%_.apk
del %APKOUTPUT%\%APKNAME%.apk.idsig
del %APKOUTPUT%\%APKNAME%.apk.jobf

if /I "%REQUIRES_MAGISK_MODULE%"=="y" (

	:: Cleanup zip
del ..\%APKNAME%_Magisk\*.zip

	:: Compress --> zip
%ZIP% a ..\%APKNAME%_Magisk\%ZIPNAME%.zip -xr!.git* -xr!LICENSE -r ..\%APKNAME%_Magisk\* -mx%ZIP_COMPRESSION_LEVEL%

	:: Push zip to phone
%ADB% push ..\%APKNAME%_Magisk\%ZIPNAME%.zip /sdcard/

) else (%ADB% install -r "%~dp1%APKOUTPUT%\%APKNAME%.apk")

	:: Avoid cmd closing after finish to see eventual issues
pause
