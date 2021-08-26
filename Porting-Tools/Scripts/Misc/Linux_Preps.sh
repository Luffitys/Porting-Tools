	# Update everything
sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y && sudo apt clean -y && sudo apt autoclean -y

	# Install Requirements
sudo apt install libz-dev unzip build-essential openjdk-8-jdk-headless -y

	# Prepare vdexExtractor
git clone https://github.com/anestisb/vdexExtractor.git
cd vdexExtractor
./make.sh
cd ..

	# Prepare (Bak-)Smali
git clone https://github.com/JesusFreke/smali.git
cd smali
./gradlew
./gradlew build
cd ..

	# Prepare Apktool
git clone https://github.com/iBotPeaches/Apktool.git
cd Apktool
./gradlew
./gradlew build
cd ..

	# Clean Tools
rm -rf /mnt/d/Porting-Tools/Porting-Tools_Misc/Tools/APKTool/*smali.jar
rm -rf /mnt/d/Porting-Tools/Porting-Tools_Misc/Tools/APKTool/apktool.jar

	# Copy (Bak-)Smali, Apktool
cp smali/baksmali/build/libs/baksmali-*-fat.jar /mnt/d/Porting-Tools/Porting-Tools_Misc/Tools/APKTool/
cp smali/smali/build/libs/smali-*-fat.jar /mnt/d/Porting-Tools/Porting-Tools_Misc/Tools/APKTool/
cp Apktool/brut.apktool/apktool-cli/build/libs/apktool-*-small.jar /mnt/d/Porting-Tools/Porting-Tools_Misc/Tools/APKTool/

	# Rename Tools
mv /mnt/d/Porting-Tools/Porting-Tools_Misc/Tools/APKTool/baksmali*.jar /mnt/d/Porting-Tools/Porting-Tools_Misc/Tools/APKTool/baksmali.jar
mv /mnt/d/Porting-Tools/Porting-Tools_Misc/Tools/APKTool/smali*.jar /mnt/d/Porting-Tools/Porting-Tools_Misc/Tools/APKTool/smali.jar
mv /mnt/d/Porting-Tools/Porting-Tools_Misc/Tools/APKTool/apktool-*-small.jar /mnt/d/Porting-Tools/Porting-Tools_Misc/Tools/APKTool/apktool.jar

	# Clean Build Directories
rm -rf smali
rm -rf Apktool