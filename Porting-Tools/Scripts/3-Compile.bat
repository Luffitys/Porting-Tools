@echo off

	:: Enter the file's name without the "_DECOMPILED" directory suffix
set FILENAME=
	:: Enter the file's extension (apk/jar)
set FILEEXTENSION=
	:: If the file is a .jar file, define the --min-sdk-version (Android 11 = 30)
set JARAVERSION=
	:: If a Magisk Module is required, enter "y", otherwise leave blank
set REQUIRES_MAGISK_MODULE=
	:: If using Magisk module, enter the path the file should be in (no "\" at beginning or end)
set FILEPATH=
	:: If the original manifest should be used, enter "y", otherwise leave blank
set COPY_ORIGINAL_MANIFEST=
	:: If the file should be compiled with AAPT2, enter "y", otherwise leave blank
set COMPILE_WITH_AAPT2=
	:: CRASH FIX: If using Magisk module and if the file's libs should be copied to the Magisk directory, enter "y", otherwise leave blank
set REQUIRES_LIB_COPYING=
	:: If using Magisk module, enter a value ranging from 0-9, 0 being the lowest and 9 the highest compression level
set ZIP_COMPRESSION_LEVEL=4

set APKTOOL=Tools\APKTool
set ZIPNAME=%FILENAME%_Mod
set ZIP=Tools\7z\7z.exe
set ADB=Tools\adb\adb.exe

if /I not "%JARAVERSION%"=="" (
if /I "%FILEEXTENSION%"=="jar" (
	set JARAVERSION=--min-sdk-version %JARAVERSION%
)
)
if /I "%COPY_ORIGINAL_MANIFEST%"=="y" (
set COPY_ORIGINAL_MANIFEST=-c
)
if /I "%COMPILE_WITH_AAPT2%"=="y" (
set COMPILE_WITH_AAPT2=--use-aapt2
)
if /I "%REQUIRES_MAGISK_MODULE%"=="y" (
set FILEOUTPUT=..\%FILENAME%_Magisk\%FILEPATH%
) else (
set FILEOUTPUT=..\%FILENAME%_DECOMPILED
)

@echo on
cd ..

if /I "%REQUIRES_MAGISK_MODULE%"=="y" (
if /I "%REQUIRES_LIB_COPYING%"=="y" (
	mkdir %FILEOUTPUT%\lib\
	move ..\%FILENAME%_DECOMPILED\lib\arm64-v8a %FILEOUTPUT%\lib\
	ren %FILEOUTPUT%\lib\arm64-v8a arm64
	rmdir /Q /S ..\%FILENAME%_DECOMPILED\lib
)
)

	:: Compile
java -jar %APKTOOL%\apktool.jar b --no-crunch %COMPILE_WITH_AAPT2% %COPY_ORIGINAL_MANIFEST% --output %FILEOUTPUT%\%FILENAME%_.%FILEEXTENSION% ..\%FILENAME%_DECOMPILED  -p %APKTOOL%\Frameworks
	:: Zipalign
%APKTOOL%\zipalign.exe -f 4 %FILEOUTPUT%\%FILENAME%_.%FILEEXTENSION% %FILEOUTPUT%\%FILENAME%.%FILEEXTENSION%
	:: Sign
java -jar %APKTOOL%\ApkSigner.jar sign %JARAVERSION% --key %APKTOOL%\Misc\PrivateKey.pk8 --cert %APKTOOL%\Misc\PublicKey.pem %FILEOUTPUT%\%FILENAME%.%FILEEXTENSION%
	:: Cleanup
del %FILEOUTPUT%\%FILENAME%_.%FILEEXTENSION%
del %FILEOUTPUT%\%FILENAME%.%FILEEXTENSION%.idsig
del %FILEOUTPUT%\%FILENAME%.%FILEEXTENSION%.jobf
if /I "%REQUIRES_MAGISK_MODULE%"=="y" (
		:: Cleanup zip
	del ..\%FILENAME%_Magisk\*.zip
		:: Compress --> zip
	%ZIP% a ..\%FILENAME%_Magisk\%ZIPNAME%.zip -xr!.git* -xr!LICENSE -r ..\%FILENAME%_Magisk\* -mx%ZIP_COMPRESSION_LEVEL%
		:: Push zip to phone
	%ADB% push ..\%FILENAME%_Magisk\%ZIPNAME%.zip /sdcard/
) else (
	%ADB% install -r "%~dp1%FILEOUTPUT%\%FILENAME%.%FILEEXTENSION%"
)

	:: Avoid cmd closing after finish to see eventual issues
pause
