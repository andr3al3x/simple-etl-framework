@echo off

SETLOCAL
:: configuration
set BASEDIR=%~dp0

call %BASEDIR%\base\pan.bat tests/unit/a_plus_b_mapping_test.ktr 
endlocal
