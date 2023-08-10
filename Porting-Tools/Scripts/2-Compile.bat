@echo off

	:: Type in the folder's name to be compiled
set FILENAME=
	:: If the apk requires a Magisk module
	:: Set to 'y'
	:: Otherwise leave blank
set REQUIRES_MAGISK_MODULE=
	:: If using Magisk module
	:: Enter the path the apk should be in
	:: (no "\" at beginning or end)
	:: Example: product\priv-app\MiuiCamera
set FILEPATH=
	:: If the file should be compiled with AAPT2
	:: Set to 'y'
	:: Otherwise leave blank
set COMPILE_WITH_AAPT2=
	:: Magisk module compression level. Range: 0-9
	:: Only used if a Magisk module is used
set ZIP_COMPRESSION_LEVEL=5


set APKTOOL=Tools\apktool
set APKSIGNER=Tools\apksigner
set ZIPNAME=%FILENAME%_Module
set ZIP=Tools\7z\7z.exe
set ADB=Tools\adb\adb.exe

if /I "%COMPILE_WITH_AAPT2%"=="y" (
	set "COMPILE_WITH_AAPT2=--use-aapt2"
)

if /I "%REQUIRES_MAGISK_MODULE%"=="y" (
	set "FILEOUTPUT=out\%FILENAME%_Magisk\system\%FILEPATH%"
) else (
	set "FILEOUTPUT=out\%FILENAME%"
)

cd ..

if not exist "out" (
	md "out"
)

java -jar "%APKTOOL%\apktool.jar" b %COMPILE_WITH_AAPT2% %COPY_ORIGINAL_MANIFEST% --output "%FILEOUTPUT%\%FILENAME%.apk" "out\%FILENAME%"

java -jar "%APKSIGNER%\apksigner.jar" -a "%FILEOUTPUT%\%FILENAME%.apk" --overwrite

del "%FILEOUTPUT%\%FILENAME%.apk.idsig"

if /I "%REQUIRES_MAGISK_MODULE%"=="y" (
	del "out\%FILENAME%_Magisk\*.zip"
	%ZIP% a "out\%FILENAME%_Magisk\%ZIPNAME%.zip" -r "out\%FILENAME%_Magisk\*" -mx%ZIP_COMPRESSION_LEVEL%
	%ADB% push "out\%FILENAME%_Magisk\%ZIPNAME%.zip" /sdcard/
) else (
	%ADB% install -r "%FILEOUTPUT%\%FILENAME%.apk"
)

pause
