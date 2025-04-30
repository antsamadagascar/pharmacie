@echo off
setlocal enabledelayedexpansion

REM ===== CONFIGURATION =====
REM Détection automatique de JAVA_HOME ou utilisation de la version système
if defined JAVA_HOME (
    set "JAVA_BIN=%JAVA_HOME%\bin"
    echo Utilisation de JAVA_HOME: %JAVA_HOME%
) else (
    set "JAVA_BIN="
    echo Utilisation de Java système
)

REM Configuration des chemins (modifiables selon votre environnement)
set "root=C:\xampp\tomcat\webapps\pharmacies"
set "target_dir=%root%\lib"
set "config_target_dir=%root%\WEB-INF\classes\config"
set "temp=%root%\temp"
set "src=%root%\src"
set "lib=%root%\lib"
set "bin=%root%\bin"
set "jar_name=pharmacies"

REM ===== DÉTECTION DE LA VERSION JAVA =====
echo Détection de la version Java...
if defined JAVA_BIN (
    "%JAVA_BIN%\java" -version 2>&1 | findstr "version" > java_version.tmp
) else (
    java -version 2>&1 | findstr "version" > java_version.tmp
)

set /p JAVA_VERSION_LINE=<java_version.tmp
del java_version.tmp

REM Extraction du numéro de version majeure
for /f "tokens=3 delims= " %%a in ("%JAVA_VERSION_LINE%") do set JAVA_VERSION_FULL=%%a
set JAVA_VERSION_FULL=%JAVA_VERSION_FULL:"=%

REM Détermination de la version majeure (Java 8 = 1.8, Java 11+ = 11, 17, etc.)
for /f "tokens=1,2 delims=." %%a in ("%JAVA_VERSION_FULL%") do (
    if "%%a"=="1" (
        set JAVA_MAJOR=%%b
    ) else (
        set JAVA_MAJOR=%%a
    )
)

echo Version Java détectée: %JAVA_MAJOR%

REM ===== CONFIGURATION DE LA COMPILATION =====
REM Définition des options de compilation selon la version
set "COMPILE_OPTIONS="
if %JAVA_MAJOR% GEQ 9 (
    REM Pour Java 9+, utiliser --release pour la compatibilité
    if %JAVA_MAJOR% GEQ 17 (
        set "COMPILE_OPTIONS=--release 17"
        echo Compilation avec --release 17
    ) else if %JAVA_MAJOR% GEQ 11 (
        set "COMPILE_OPTIONS=--release 11"
        echo Compilation avec --release 11
    ) else (
        set "COMPILE_OPTIONS=--release 9"
        echo Compilation avec --release 9
    )
) else (
    REM Pour Java 8, utiliser -source et -target
    set "COMPILE_OPTIONS=-source 1.8 -target 1.8"
    echo Compilation avec source/target 1.8
)

REM ===== PRÉPARATION DES RÉPERTOIRES =====
echo Préparation des répertoires...
if not exist "%temp%" mkdir "%temp%"
if not exist "%bin%" mkdir "%bin%"
if not exist "%target_dir%" mkdir "%target_dir%"
if not exist "%config_target_dir%" mkdir "%config_target_dir%"

REM Nettoyage des répertoires temporaires
if exist "%temp%\*" del /q "%temp%\*"
if exist "%bin%\*" rmdir /s /q "%bin%" && mkdir "%bin%"

REM ===== COPIE DES SOURCES =====
echo Copie des fichiers source...
for /r "%src%" %%f in (*.java) do (
    copy "%%f" "%temp%" >nul
)

REM Vérification qu'il y a des fichiers Java
dir "%temp%\*.java" >nul 2>&1
if errorlevel 1 (
    echo ERREUR: Aucun fichier .java trouvé dans %src%
    goto :error
)

REM ===== COMPILATION =====
echo Compilation en cours...
cd "%temp%"

REM Construction de la commande de compilation
set "CLASSPATH_ARG="
if exist "%lib%\*.jar" (
    set "CLASSPATH_ARG=-cp "%lib%\*""
)

REM Exécution de la compilation
if defined JAVA_BIN (
    "%JAVA_BIN%\javac" %COMPILE_OPTIONS% -d "%bin%" %CLASSPATH_ARG% *.java
) else (
    javac %COMPILE_OPTIONS% -d "%bin%" %CLASSPATH_ARG% *.java
)

if errorlevel 1 (
    echo ERREUR: Échec de la compilation
    goto :error
)

echo Compilation réussie!

REM ===== CRÉATION DU JAR =====
echo Création du fichier JAR...
cd "%bin%"

if defined JAVA_BIN (
    "%JAVA_BIN%\jar" -cvf "%jar_name%.jar" . >nul
) else (
    jar -cvf "%jar_name%.jar" . >nul
)

if errorlevel 1 (
    echo ERREUR: Échec de la création du JAR
    goto :error
)

REM ===== DÉPLOIEMENT =====
echo Déploiement des fichiers...
copy "%jar_name%.jar" "%target_dir%" >nul
if errorlevel 1 (
    echo ERREUR: Échec de la copie du JAR
    goto :error
)

REM Copie des fichiers de configuration
if exist "%bin%\config\config.properties" (
    copy "%bin%\config\config.properties" "%config_target_dir%" >nul
)

REM Copie de toutes les classes vers WEB-INF/classes
if not exist "%root%\WEB-INF\classes" mkdir "%root%\WEB-INF\classes"
xcopy /s /e /i /y "%bin%\*" "%root%\WEB-INF\classes\" >nul

REM ===== NETTOYAGE =====
echo Nettoyage...
cd "%root%"
if exist "%temp%" rmdir /s /q "%temp%"

echo.
echo ===== BUILD TERMINÉ AVEC SUCCÈS =====
echo Version Java utilisée: %JAVA_MAJOR%
echo JAR créé: %target_dir%\%jar_name%.jar
echo.

REM ===== LANCEMENT OPTIONNEL =====
set /p launch="Lancer l'application? (o/N): "
if /i "%launch%"=="o" (
    echo Lancement de l'application...
    timeout /t 3 /nobreak >nul 2>&1
    start "" "http://localhost:8080/pharmacies/"
) else (
    echo Application prête à être lancée: http://localhost:8080/pharmacies/
)

goto :end

:error
echo.
echo ===== ERREUR LORS DU BUILD =====
cd "%root%"
if exist "%temp%" rmdir /s /q "%temp%"
pause
exit /b 1

:end
echo Build terminé. Appuyez sur une touche pour continuer...
pause >nul
exit /b 0