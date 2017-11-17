@echo off
SETLOCAL
CALL "%~dp0/init.bat"

if errorlevel 1 (
   echo Failure setting up the environment.
   exit /b %errorlevel%
)

SET FILE=%1
SHIFT
CALL "%PENTAHO_HOME%/kitchen.bat" /file:"%REPO_HOME%\%FILE%" %*
