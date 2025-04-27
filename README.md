# Pharmacie - Guide d'installation et de déploiement

## Prérequis

Avant d'utiliser ce projet, assurez-vous d'avoir installé :

- **JDK 19.0.2**
- **XAMPP v3.3.0** (incluant Tomcat)
- **PostgreSQL 15**

## Base de données

Exécutez les scripts SQL situés dans le dossier `sql` dans l'ordre suivant :

1. `table`
2. `data`
3. `view`
4. `function`

## Installation

Clonez le projet depuis le dépôt GitHub :

```bash
git clone https://github.com/antsamadagascar/Pharmacie.git

Déploiement

   1.  Ouvrez le fichier build.bat.

   2.  Modifiez les chemins suivants selon votre installation de Tomcat :
   set "root=C:\xampp\tomcat\webapps\pharmacies"
   set "target_dir=C:\xampp\tomcat\webapps\pharmacies\lib"
   set "config_target_dir=C:\xampp\tomcat\webapps\pharmacies\web\WEB-INF\classes\config"


   3. Positionnez-vous dans le dossier contenant build.bat.

   4. Exécutez dans un terminal ou PowerShell :
   build.bat
