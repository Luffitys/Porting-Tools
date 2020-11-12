@echo off

set /p EXTRACT_VENDOR="Do you want to extract the vendor partition? (y/n): "
set /p INSTALL_FRAMEWORKS="Do you want to install APKTool frameworks? (y/n): "
set /p EXTRACT_CLASSES="Do you want to extract system classes? (y/n): "

set SYSTEM=ROM\ROM\system
set VENDOR=ROM\ROM\vendor
set CLASSES=ROM\Classes
set APKTOOL=Tools\APKTool
set EXTRACTOR=Tools\Extractor
set ZIP=Tools\7z\7z.exe

	:: Extract System from .zip
@echo on

cd ..

%ZIP% x .\*.zip -oTEMP\ system.new.dat.br system.transfer.list -bse0 -bso0

	:: Convert .dat.br -> .dat
%Extractor%\Brotli.exe --decompress --in TEMP\system.new.dat.br --out TEMP\system.new.dat

	:: Convert .dat -> .img
%Extractor%\sdat2Img.exe TEMP\system.transfer.list TEMP\system.new.dat TEMP\system.img >nul

	:: Extract system.img
%ZIP% x -aos TEMP\system.img -o%SYSTEM% -bse0 -bso0

	:: Extract Vendor from .zip
if /I "%EXTRACT_VENDOR%"=="y" (

%ZIP% x *.zip -oTEMP\ vendor.new.dat.br vendor.transfer.list -bse0 -bso0

	:: Convert .dat.br -> .dat
%Extractor%\Brotli.exe --decompress --in TEMP\vendor.new.dat.br --out TEMP\vendor.new.dat

	:: Convert .dat -> .img
%Extractor%\sdat2Img.exe TEMP\vendor.transfer.list TEMP\vendor.new.dat TEMP\vendor.img >nul

	:: Extract vendor.img
%ZIP% x -aos TEMP\vendor.img -o%VENDOR% -bse0 -bso0

)

	:: Add Frameworks
if /I "%INSTALL_FRAMEWORKS%"=="y" (

java -jar %APKTOOL%\apktool.jar if %SYSTEM%\system\framework\framework-res.apk -p %APKTOOL%\Frameworks

java -jar %APKTOOL%\apktool.jar if %SYSTEM%\system\framework\framework-ext-res\framework-ext-res.apk -p %APKTOOL%\Frameworks

java -jar %APKTOOL%\apktool.jar if %SYSTEM%\system\app\miui\miui.apk -p %APKTOOL%\Frameworks

java -jar %APKTOOL%\apktool.jar if %SYSTEM%\system\app\miuisystem\miuisystem.apk -p %APKTOOL%\Frameworks

java -jar %APKTOOL%\apktool.jar if %SYSTEM%\system\priv-app\MiuiSystemUI\MiuiSystemUI.apk -p %APKTOOL%\Frameworks

)

	:: Extract Classes [Trial and Error]

if /I "%EXTRACT_CLASSES%"=="y" (

	:: miui.apk
%ZIP% x %SYSTEM%\system\app\miui\miui.apk -oTEMP\miui *.dex -bse0 -bso0

	:: miuisystem.apk
%ZIP% x %SYSTEM%\system\app\miuisystem\miuisystem.apk -oTEMP\miuisystem *.dex -bse0 -bso0

	:: framework.jar
%ZIP% x %SYSTEM%\system\framework\framework.jar -oTEMP\framework *.dex -bse0 -bso0

	:: gson.jar
%ZIP% x %SYSTEM%\system\framework\gson.jar -oTEMP\gson *.dex -bse0 -bso0

	:: Decompile Classes
java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\miui TEMP\miui\classes.dex
java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\miuisystem TEMP\miuisystem\classes.dex
java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\framework TEMP\framework\classes.dex
java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\framework2 TEMP\framework\classes2.dex
java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\framework3 TEMP\framework\classes3.dex
java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\framework4 TEMP\framework\classes4.dex
java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\gson TEMP\gson\classes.dex

)

	:: Cleanup
rmdir /Q /S TEMP

	:: Avoid closing of CMD to see potential issues
pause
