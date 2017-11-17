@echo off

SET "BASE_DIR=%~dp0"
SET "ENV_DIR=%BASE_DIR%..\..\environments"
IF "%PENTAHO_ENV%"=="" (SET PENTAHO_ENV=local)
IF "%PENTAHO_EXEC_RUNTIME%"=="" (SET PENTAHO_EXEC_RUNTIME=development)
SET "KETTLE_HOME=%ENV_DIR%\%PENTAHO_ENV%\%PENTAHO_EXEC_RUNTIME%"
SET "REPO_HOME=%BASE_DIR%..\..\repository"

REM check if the environment folder exists
IF EXIST "%KETTLE_HOME%" (
  echo Running with %PENTAHO_ENV%\%PENTAHO_EXEC_RUNTIME% environment settings
) else (
  echo Please configure the %PENTAHO_ENV%\%PENTAHO_EXEC_RUNTIME% environment correctly
  exit /b 1
)

REM load environment configuration
for /F "usebackq delims=" %%x in ("%KETTLE_HOME%\boot.conf") do (set %%x)

REM check if a valid PDI installation folder has been provided
if "%PENTAHO_HOME%"=="" (
  echo Please set the default PENTAHO_HOME
  exit /b 1
)

if exist "%PENTAHO_HOME%\Spoon.bat" (
  echo Found Spoon.bat continuing initialization
) else (
  echo Invalid PENTAHO_HOME folder, could not find Spoon.bat
  exit /b 1
)

REM check if a valid environment startup has been provided
if "%PENTAHO_DI_JAVA_OPTIONS%"=="" (
  echo Please set the default PENTAHO_DI_JAVA_OPTIONS
  exit /b 1
) else (
  SET OPT=%OPT% "-DPENTAHO_METASTORE_FOLDER=%KETTLE_HOME%" "-DREPO_HOME=%REPO_HOME%"
)

REM check if there is a custom JAVA_HOME set
if "%PENTAHO_JAVA_HOME%"=="" (
  echo No PENTAHO_JAVA_HOME set, continuing with system wide default
)
