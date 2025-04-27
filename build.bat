@echo off

set "root=C:\xampp\tomcat\webapps\pharmacies"
set "target_dir=%root%\lib"
set "config_target_dir=%root%\web\WEB-INF\classes\config"

set "temp=%root%\temp"
set "src=%root%\src"
set "lib=%root%\lib"
set "bin=%root%\bin"
set "jar_name=pharmacies"

if not exist "%temp%" mkdir "%temp%"
if not exist "%bin%" mkdir "%bin%"

for /r "%src%" %%f in (*.java) do (
    xcopy "%%f" "%temp%"
)

cd "%temp%"
javac --release 17 -d "%bin%" -cp "%lib%\*" *.java
cd "%bin%"
jar -cvf "%jar_name%.jar" .

copy "%jar_name%.jar" "%target_dir%"
xcopy "%bin%\config\config.properties" "%config_target_dir%" /y
xcopy /s /e /i "%bin%\*" "%root%\WEB-INF\classes\"

cd "%root%"
rmdir /s /q "%temp%"

timeout /t 15 /nobreak >nul 2>&1
start "" "http://localhost:8080/pharmacies/"
