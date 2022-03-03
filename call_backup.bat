@echo off

REM robocopy /m option only copies files with Archive bit set and then resets the Archive bit
REM robocopy /e option copies all subdirectories including empty ones

setlocal enableextensions enabledelayedexpansion

set backupType=%~1
if [%backupType%]==[] (
	echo Missing arguments. Usage described in README file.
	goto END_FAILED
)

REM set paths to destination & backup scripts
SET workingDir=%~dp0
FOR %%a IN ("%workingDir:~0,-1%") DO SET destDir=%%~dpaBackup\
SET scriptReadFromIni=%workingDir%readFromIni.bat
SET configPath=%workingDir%__config.ini

REM get and store the settings from config file
REM get directory paths to backup ... sourcePaths initialized to empty string (stupid syntax)
set sourcePaths=
for /f "tokens=* USEBACKQ" %%F in (`call "%scriptReadFromIni%" "%configPath%" BackupConfig sourcePath`) do (
	set p=%%F
	IF /I "!p:~0,3!" NEQ "C:\" (
		echo error: !p!
		echo		is not a full path.
		echo		Paths should begin with "C:\"
		GOTO END_FAILED
	)
	set sourcePaths=!sourcePaths! !p:~3!
)

REM remove trailing and leading spaces
for /l %%a in (1,1,100) do if "!sourcePaths:~-1!"==" " set sourcePaths=!sourcePaths:~0,-1!

REM show backup source list and backup type to the user
echo backupType: %backupType%
ECHO Backup source paths:
FOR %%a IN (%sourcePaths%) DO echo 	%%a

REM get confirmation from the user
SET /P confirm="Continue? (y/[N])? "
IF /I "%confirm%" NEQ "Y" (
	GOTO END_CANCELLED
)
echo:

REM ----------------------------------------------------------------
REM confirmed, now do the copy

SET logFilename=backup_log.txt
SET logDest=%destDir%%logFilename%

FOR %%a IN (%sourcePaths%) DO (

	SET sourceDir=C:\%%a
	SET destDirFull=%destDir%C\%%a
	echo ------------------------------------------------------------------
	echo --- src: !sourceDir!
	echo --- dest: !destDirFull!
	echo:

	REM create folder structure for destination
	IF NOT EXIST "!destDirFull!" ( mkdir "!destDirFull!" )

	IF /I "%backupType%" == "EVERYTHING" (
		REM robocopy "%sourceDir%\" "%destDirFull%\" /e /is /it /tee /log:"%logDest%"
		ECHO robocopy "%sourceDir%\" "%destDirFull%\" /e /is /it /tee /log:"%logDest%"
	)

	IF /I "%backupType%" == "MODIFIED" (
		REM robocopy "%dirSourcePublic%\" "%dirDestPublic%\" /e /m /tee /log:"%pathBackupLogPublic%"
		ECHO robocopy "%dirSourcePublic%\" "%dirDestPublic%\" /e /m /tee /log:"%pathBackupLogPublic%"
	)

	echo:

)

REM ----------------------------------------------------------------
:END_WAIT
	echo Press any key to exit...
	pause >nul
	GOTO END
:END_CANCELLED
	echo Backup cancelled. Press any key to exit...
	pause >nul
	GOTO END
:END_FAILED
	echo Backup failed. Press any key to exit...
	pause >nul
	GOTO END
:END
	endlocal
