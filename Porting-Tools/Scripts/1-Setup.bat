@echo off

set /p EXTENSION="What extension does the compressed file in the .zip have? (.dat.br/.bin): "
set /p EXTRACT_ALL="Do you want to extract all partitions? (all=system,vendor,product,system_ext,cust,odm):(y/n): "
if /I "%EXTRACT_ALL%"=="n" (
	set /p EXTRACT_SYSTEM="Do you want to extract the system partition? (y/n): "
	set /p EXTRACT_VENDOR="Do you want to extract the vendor partition? (y/n): "
	set /p EXTRACT_PRODUCT="Do you want to extract the product partition? (y/n): "
	set /p EXTRACT_SYSTEM_EXT="Do you want to extract the system_ext partition? (y/n): "
	set /p EXTRACT_CUST="Do you want to extract the cust partition? (y/n): "
	set /p EXTRACT_ODM="Do you want to extract the odm partition? (y/n): "
) else (
	set EXTRACT_SYSTEM=y
	set EXTRACT_VENDOR=y
	set EXTRACT_PRODUCT=y
	set EXTRACT_SYSTEM_EXT=y
	set EXTRACT_CUST=y
	set EXTRACT_ODM=y
)
set /p INSTALL_FRAMEWORKS="Do you want to install APKTool frameworks? (y/n): "
set /p EXTRACT_CLASSES="Do you want to extract system classes? (.EU ROM only) (y/n): "

set ROM=ROM\ROM
set SYSTEM=%ROM%\system
set VENDOR=%ROM%\vendor
set PRODUCT=%ROM%\product
set SYSTEM_EXT=%ROM%\system_ext
set CUST=%ROM%\cust
set ODM=%ROM%\odm
set CLASSES=ROM\Classes
set APKTOOL=Tools\APKTool
set EXTRACTOR=Tools\Extractor
set ZIP=Tools\7z\7z.exe

@echo on
cd ..

if /I "%EXTENSION%"==".dat.br" (
if /I "%EXTRACT_SYSTEM%"=="y" (
		:: Extract system partition from .zip
	%ZIP% x input\*.zip -oTEMP\ system.new.dat.br system.transfer.list -bse0 -bso0
		:: Convert .dat.br -> .dat
	%Extractor%\Brotli.exe --decompress --in TEMP\system.new.dat.br --out TEMP\system.new.dat
		:: Convert .dat -> .img
	%Extractor%\sdat2Img.exe TEMP\system.transfer.list TEMP\system.new.dat TEMP\system.img >nul
		:: Extract system.img
	%ZIP% x -aos TEMP\system.img -o%SYSTEM% -bse0 -bso0
)
if /I "%EXTRACT_VENDOR%"=="y" (
		:: Extract vendor partition from .zip
	%ZIP% x input\*.zip -oTEMP\ vendor.new.dat.br vendor.transfer.list -bse0 -bso0
		:: Convert .dat.br -> .dat
	%Extractor%\Brotli.exe --decompress --in TEMP\vendor.new.dat.br --out TEMP\vendor.new.dat
		:: Convert .dat -> .img
	%Extractor%\sdat2Img.exe TEMP\vendor.transfer.list TEMP\vendor.new.dat TEMP\vendor.img >nul
		:: Extract vendor.img
	%ZIP% x -aos TEMP\vendor.img -o%VENDOR% -bse0 -bso0
)
if /I "%EXTRACT_PRODUCT%"=="y" (
		:: Extract product partition from .zip
	%ZIP% x input\*.zip -oTEMP\ product.new.dat.br product.transfer.list -bse0 -bso0
		:: Convert .dat.br -> .dat
	%Extractor%\Brotli.exe --decompress --in TEMP\product.new.dat.br --out TEMP\product.new.dat
		:: Convert .dat -> .img
	%Extractor%\sdat2Img.exe TEMP\product.transfer.list TEMP\product.new.dat TEMP\product.img >nul
		:: Extract product.img
	%ZIP% x -aos TEMP\product.img -o%PRODUCT% -bse0 -bso0
)
if /I "%EXTRACT_SYSTEM_EXT%"=="y" (
		:: Extract system_ext partition from .zip
	%ZIP% x input\*.zip -oTEMP\ system_ext.new.dat.br system_ext.transfer.list -bse0 -bso0
		:: Convert .dat.br -> .dat
	%Extractor%\Brotli.exe --decompress --in TEMP\system_ext.new.dat.br --out TEMP\system_ext.new.dat
		:: Convert .dat -> .img
	%Extractor%\sdat2Img.exe TEMP\system_ext.transfer.list TEMP\system_ext.new.dat TEMP\system_ext.img >nul
		:: Extract system_ext.img
	%ZIP% x -aos TEMP\system_ext.img -o%SYSTEM_EXT% -bse0 -bso0
)
if /I "%EXTRACT_CUST%"=="y" (
		:: Extract cust partition from .zip
	%ZIP% x input\*.zip -oTEMP\ cust.new.dat.br cust.transfer.list -bse0 -bso0
		:: Convert .dat.br -> .dat
	%Extractor%\Brotli.exe --decompress --in TEMP\cust.new.dat.br --out TEMP\cust.new.dat
		:: Convert .dat -> .img
	%Extractor%\sdat2Img.exe TEMP\cust.transfer.list TEMP\cust.new.dat TEMP\cust.img >nul
		:: Extract cust.img
	%ZIP% x -aos TEMP\cust.img -o%CUST% -bse0 -bso0
)
if /I "%EXTRACT_ODM%"=="y" (
		:: Extract odm partition from .zip
	%ZIP% x input\*.zip -oTEMP\ odm.new.dat.br odm.transfer.list -bse0 -bso0
		:: Convert .dat.br -> .dat
	%Extractor%\Brotli.exe --decompress --in TEMP\odm.new.dat.br --out TEMP\odm.new.dat
		:: Convert .dat -> .img
	%Extractor%\sdat2Img.exe TEMP\odm.transfer.list TEMP\odm.new.dat TEMP\odm.img >nul
		:: Extract odm.img
	%ZIP% x -aos TEMP\odm.img -o%ODM% -bse0 -bso0
)
) else (
		:: Extract payload.bin from .zip
	%ZIP% x input\*.zip -oTEMP\ payload.bin -bse0 -bso0
if /I "%EXTRACT_ALL%"=="y" (
		:: Decompress payload.bin
	Tools\Extractor\payload-dumper-go.exe -p system,vendor,system_ext,product TEMP\payload.bin
) else (
if /I "%EXTRACT_SYSTEM%"=="y" (
	Tools\Extractor\payload-dumper-go.exe -p system TEMP\payload.bin
)
if /I "%EXTRACT_VENDOR%"=="y" (
	Tools\Extractor\payload-dumper-go.exe -p vendor TEMP\payload.bin
)
if /I "%EXTRACT_PRODUCT%"=="y" (
	Tools\Extractor\payload-dumper-go.exe -p product TEMP\payload.bin
)
if /I "%EXTRACT_SYSTEM_EXT%"=="y" (
	Tools\Extractor\payload-dumper-go.exe -p system_ext TEMP\payload.bin
)
if /I "%EXTRACT_CUST%"=="y" (
	Tools\Extractor\payload-dumper-go.exe -p cust TEMP\payload.bin
)
if /I "%EXTRACT_ODM%"=="y" (
	Tools\Extractor\payload-dumper-go.exe -p odm TEMP\payload.bin
)
)
		:: Move .img files to TEMP\
	mv extracted_*/* TEMP\
	rm -rf extracted_*

if /I "%EXTRACT_SYSTEM%"=="y" (
		:: Extract system.img
	%ZIP% x -aos TEMP\system.img -o%SYSTEM% -bse0 -bso0
)
if /I "%EXTRACT_VENDOR%"=="y" (
		:: Extract vendor.img
	%ZIP% x -aos TEMP\vendor.img -o%VENDOR% -bse0 -bso0
)
if /I "%EXTRACT_PRODUCT%"=="y" (
		:: Extract product.img
	%ZIP% x -aos TEMP\product.img -o%PRODUCT% -bse0 -bso0
)
if /I "%EXTRACT_SYSTEM_EXT%"=="y" (
		:: Extract system_ext.img
	%ZIP% x -aos TEMP\system_ext.img -o%SYSTEM_EXT% -bse0 -bso0
)
if /I "%EXTRACT_CUST%"=="y" (
		:: Extract cust.img
	%ZIP% x -aos TEMP\cust.img -o%CUST% -bse0 -bso0
)
if /I "%EXTRACT_ODM%"=="y" (
		:: Extract odm.img
	%ZIP% x -aos TEMP\odm.img -o%ODM% -bse0 -bso0
)
)

if /I "%INSTALL_FRAMEWORKS%"=="y" (
		:: Add Frameworks
	java -jar %APKTOOL%\apktool.jar if %SYSTEM%\system\framework\framework-res.apk -p %APKTOOL%\Frameworks
	java -jar %APKTOOL%\apktool.jar if %SYSTEM%\system\framework\framework-ext-res\framework-ext-res.apk -p %APKTOOL%\Frameworks
	java -jar %APKTOOL%\apktool.jar if %SYSTEM%\system\app\miui\miui.apk -p %APKTOOL%\Frameworks
	java -jar %APKTOOL%\apktool.jar if %SYSTEM%\system\app\miuisystem\miuisystem.apk -p %APKTOOL%\Frameworks
	java -jar %APKTOOL%\apktool.jar if %SYSTEM_EXT%\priv-app\MiuiSystemUI\MiuiSystemUI.apk -p %APKTOOL%\Frameworks

)

if /I "%EXTRACT_CLASSES%"=="y" (
		:: Extract classes
		:: miui.apk
	%ZIP% x %SYSTEM%\system\app\miui\miui.apk -oTEMP\miui *.dex -bse0 -bso0
		:: miuisystem.apk
	%ZIP% x %SYSTEM%\system\app\miuisystem\miuisystem.apk -oTEMP\miuisystem *.dex -bse0 -bso0
		:: MiuiSystemUI.apk
	%ZIP% x %SYSTEM_EXT%\priv-app\MiuiSystemUI\MiuiSystemUI.apk -oTEMP\MiuiSystemUI *.dex -bse0 -bso0
		:: framework.jar
	%ZIP% x %SYSTEM%\system\framework\framework.jar -oTEMP\framework *.dex -bse0 -bso0
		:: gson.jar
	%ZIP% x %SYSTEM%\system\framework\gson.jar -oTEMP\gson *.dex -bse0 -bso0
		:: Decompile classes
	java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\miui TEMP\miui\classes.dex
	java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\miuisystem TEMP\miuisystem\classes.dex
	java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\MiuiSystemUI TEMP\MiuiSystemUI\classes.dex
	java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\MiuiSystemUI2 TEMP\MiuiSystemUI\classes2.dex
	java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\framework TEMP\framework\classes.dex
	java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\framework2 TEMP\framework\classes2.dex
	java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\framework3 TEMP\framework\classes3.dex
	java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\framework4 TEMP\framework\classes4.dex
	java -jar %APKTOOL%\baksmali.jar d -o %CLASSES%\gson TEMP\gson\classes.dex
)

	:: Cleanup
set /p CLEANUP="Do you want to clean up the temp directory? (y/n): "
if /I "%CLEANUP%"=="y" (
rmdir /Q /S TEMP
)

	:: Avoid closing the CMD to see potential issues
pause
