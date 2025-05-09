# Pharmacie - Installation & Deployment Guide

## Prerequisites

Before using this project, make sure you have the following installed:

- **JDK 17 or later** (recommended: JDK 19.0.2)
- **XAMPP v3.3.0** (with Tomcat included)
- **PostgreSQL 15**

## Database Setup

Execute the SQL scripts located in the `sql` folder in the following order:

1. `table.sql`
2. `data.sql`
3. `view.sql`
4. `function.sql`

## Installation

Clone the project from GitHub:

```bash
git clone https://github.com/antsamadagascar/Pharmacie.git
```

## Deployment

1. Open the file `build.bat`.

2. Update the following paths according to your Tomcat installation:

```bat
set "root=C:\xampp\tomcat\webapps\pharmacies"
set "target_dir=%root%\lib"
set "config_target_dir=%root%\web\WEB-INF\classes\config"
```

3. Make sure your environment is using **Java 17 or newer**. You can verify by running:

```bash
java -version
```

4. Navigate to the folder containing `build.bat`.

5. Run the script in a terminal or PowerShell:

```bash
build.bat
```

The script will:

- Compile all `.java` source files with `--release 17` for compatibility with Java 17 environments.
- Create a `.jar` file.
- Copy the compiled files and configuration to the appropriate Tomcat directories.
- Launch the browser automatically at: [http://localhost:8080/pharmacies/](http://localhost:8080/pharmacies/)

> ⚠️ If you are using a different Java version (e.g., Java 11), edit the following line in `build.bat`:
>
> ```bat
> javac --release 17 -d "%bin%" -cp "%lib%\*" *.java
> ```
> Replace `--release 17` with your version (e.g., `--release 11`) as needed.
