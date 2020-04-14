@echo off


	:: Enter "y" or leave blank
set EXTRACT_VENDOR=y
set INSTALL_FRAMEWORKS=y
set EXTRACT_CLASSES=y


set SYSTEM=ROM\ROM\system
set VENDOR=ROM\ROM\vendor
set CLASSES=ROM\Classes
set APKTOOL=Tools\APKTool
set EXTRACTOR=Tools\Extractor
set ZIP=Tools\7z\7z.exe


@echo on


	:: Extract System from .zip
cd ..
%ZIP% x *.zip -oTEMP\ system.new.dat.br system.transfer.list

	:: Convert .dat.br -> .dat
%Extractor%\Brotli.exe --decompress --in TEMP\system.new.dat.br --out TEMP\system.new.dat

	:: Convert .dat -> .img
%Extractor%\sdat2Img.exe TEMP\system.transfer.list TEMP\system.new.dat TEMP\system.img

	:: Extract .img
%ZIP% x -aos TEMP\system.img -o%SYSTEM%


	:: Extract Vendor from .zip
if /I "%EXTRACT_VENDOR%"=="y" (
%ZIP% x *.zip -oTEMP\ vendor.new.dat.br vendor.transfer.list

	:: Convert .dat.br -> .dat
%Extractor%\Brotli.exe --decompress --in TEMP\vendor.new.dat.br --out TEMP\vendor.new.dat

	:: Convert .dat -> .img
%Extractor%\sdat2Img.exe TEMP\vendor.transfer.list TEMP\vendor.new.dat TEMP\vendor.img

	:: Extract .img
%ZIP% x -aos TEMP\vendor.img -o%VENDOR%

)


	:: Add Frameworks
if /I "%INSTALL_FRAMEWORKS%"=="y" (

java -jar %APKTOOL%\apktool.jar if %SYSTEM%\system\framework\framework-res.apk -p %APKTOOL%\Frameworks

java -jar %APKTOOL%\apktool.jar if %SYSTEM%\system\framework\framework-ext-res\framework-ext-res.apk -p %APKTOOL%\Frameworks

java -jar %APKTOOL%\apktool.jar if %SYSTEM%\system\app\miui\miui.apk -p %APKTOOL%\Frameworks

java -jar %APKTOOL%\apktool.jar if %SYSTEM%\system\app\miuisystem\miuisystem.apk -p %APKTOOL%\Frameworks

)


	:: Extract Classes [Trial and Error]

if /I "%EXTRACT_CLASSES%"=="y" (

	:: miui.apk
%ZIP% x %SYSTEM%\system\app\miui\miui.apk -oTEMP\miui *.dex

	:: miuisystem.apk
%ZIP% x %SYSTEM%\system\app\miuisystem\miuisystem.apk -oTEMP\miuisystem *.dex

	:: framework.jar
%ZIP% x %SYSTEM%\system\framework\framework.jar -oTEMP\framework *.dex

	:: gson.jar
%ZIP% x %SYSTEM%\system\framework\gson.jar -oTEMP\gson *.dex


	:: Decompile Classes
java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\miui TEMP\miui\classes.dex
java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\miuisystem TEMP\miuisystem\classes.dex
java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\framework TEMP\framework\classes.dex
java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\framework TEMP\framework\classes2.dex
java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\framework TEMP\framework\classes3.dex
java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\framework TEMP\framework\classes4.dex
java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\gson TEMP\gson\classes.dex

)


	:: Cleanup
rmdir /Q /S TEMP

	:: Avoid closing of CMD to see potential issues
pause
