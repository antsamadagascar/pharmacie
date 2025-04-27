@echo off

set "root=C:\xampp\tomcat\webapps\pharmacies"
set "target_dir=C:\xampp\tomcat\webapps\pharmacies\lib"
set "config_target_dir=C:\xampp\tomcat\webapps\pharmacies\web\WEB-INF\classes\config"

set "temp=%root%\temp"
set "src=%root%\src"
set "lib=%root%\lib"
set "bin=%root%\bin"
set "jar_name=pharmacies"

:: Create temp and bin directories if they don't exist
if not exist "%temp%" mkdir "%temp%"
if not exist "%bin%" mkdir "%bin%"

:: copy all java files to temp directory
for /r "%src%" %%f in (*.java) do (
    xcopy "%%f" "%temp%"
)

:: move to temp to compile all java file
cd "%temp%"
javac -d "%bin%" -cp "%lib%\*" *.java

:: move to bin to create jar
cd "%bin%"
jar -cvf "%jar_name%.jar" .

:: copy jar to target directory
copy "%jar_name%.jar" "%target_dir%"

:: Copy config.properties from bin to WEB-INF/classes/config
xcopy "%bin%\config\config.properties" "%config_target_dir%" /y
xcopy /s /e /i "%bin%\*" "%root%\WEB-INF\classes\"

:: Clean up
cd "%root%"
rmdir /s /q "%temp%"

REM Attendre que NetBeans s'ouvre
timeout /t 15 /nobreak >nul 2>&1

REM Ouvrir le navigateur par défaut avec le projet
start "" "http://localhost:8080/pharmacies/"
