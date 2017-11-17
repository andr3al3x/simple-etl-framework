@echo off

CALL "%~dp0/init.bat"

if errorlevel 1 (
   echo Failure setting up the environment.
   exit /b %errorlevel%
)

CALL "%PENTAHO_HOME%/Spoon.bat"
