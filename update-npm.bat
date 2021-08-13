@echo off

setlocal

echo ============================
echo CURRENT NODE:
call node -v
echo ============================
echo CURRENT NPM:
call npm -v
echo ============================

for /f %%i in ('node -v') do set nodeVersion=%%i

if "%nodeVersion%" == "" (
    echo node not found.
    goto Exit
)

if "%NVM_HOME%" == "" (
    echo NVM_HOME not found.
    goto Exit
)

cd %NVM_HOME%
cd %nodeVersion%

echo updating npm...
echo.

move npm npm-old
move npm.cmd npm-old.cmd
move npx npx-old
move npx.cmd npx-old.cmd

cd node_modules\
move npm npm-old

cd npm-old\bin

echo.
echo ----------------------------
echo install latest npm...
echo ----------------------------

call node npm-cli.js i -g npm@latest
IF ERRORLEVEL 1 (
	echo ============================
	echo npm upgrade was unsuccessful!
) else (
	cd %NVM_HOME%
	cd %nodeVersion%
	del npm-old
	del npm-old.cmd
	del npx-old
	del npx-old.cmd
	cd node_modules\
	RD /S/Q npm-old

	echo ============================
	echo updating npm success!
	echo.
	echo node -v
	call node -v
	echo ----------------------------
	echo npm -v
	call npm -v
)

:Exit
endlocal
echo.
pause
