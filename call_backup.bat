@echo off

rem robocopy options
REM /m 		only copies files with Archive bit set and then resets the Archive bit
REM /e  	copies all subdirectories including empty ones
rem /it 	Includes tweaked files.
rem /is 	Includes the same files.
rem /tee 	Writes the status output to the console window, as well as to the log file.
rem /MT[:n] Creates multi-threaded copies with n threads. n must be an integer between 1 and 128.
rem 		The default value for n is 8. For better performance, redirect your output using /log option.
rem /mir 	Mirrors a directory tree (equivalent to /e plus /purge).
rem         Using this option with the /e option and a destination directory, overwrites the
rem         destination directory security settings.
rem /b 	    Copies files in backup mode. Backup mode allows Robocopy to override file and folder
rem         permission settings (ACLs). This allows you to copy files you might otherwise not have
rem         access to, assuming it's being run under an account with sufficient privileges.

setlocal enableextensions enabledelayedexpansion

rem checks for argument (todo: verify argument is valid)
set backupType=%~1
if [%backupType%]==[] (
	echo Missing arguments. Usage described in README file.
	goto END_FAILED
)

REM set paths to workingDir, ini file, and ini file reader script
SET workingDir=%~dp0
FOR %%a IN ("%workingDir:~0,-1%") DO SET workingDirParent=%%~dpa
SET scriptReadFromIni=%workingDir%readFromIni.bat
SET configPath=%workingDir%__config.ini

REM get systemID from config file
for /f "tokens=* USEBACKQ" %%F in (`call "%scriptReadFromIni%" "%configPath%" BackupConfig systemID`) do (
	set systemID=%%F
)

rem set destination path
set destDir=%workingDirParent%backup %systemID%\

REM get directory paths to backup ... sourcePaths initialized to empty string (stupid syntax)
set sourcePaths=
for /f "tokens=* USEBACKQ" %%F in (`call "%scriptReadFromIni%" "%configPath%" BackupConfig sourcePath`) do (
	set p=%%F
	rem verify that source path is absolute
	IF /I "!p:~0,3!" NEQ "C:\" (
		echo error: !p!
		echo		is not a full path.
		echo		Paths should begin with "C:\"
		GOTO END_FAILED
	)
	rem fix paths without trailing backslash
	IF /I "!p:~-1!" NEQ "\" (
		set p=!p!\
	)
	rem verify that source path exists
	IF NOT EXIST "!p!" (
		echo error: !p!
		echo		does not exist.
		GOTO END_FAILED
	)
	rem add source path to list
	set sourcePaths=!sourcePaths! !p!
)

REM show backup source list and backup type to the user
echo backup type: %backupType%
ECHO backup source and destination paths:
FOR %%a IN (%sourcePaths%) DO (
	echo 	%%a
	set p=%%a
	echo 		-^> %destDir%C\!p:~3!
)

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

	SET sourceDir=%%a

	set relPath=%%a
	set relPath=!relPath:~3!

	SET destDirFull=!destDir!C\!relPath!
	echo ------------------------------------------------------------------
	echo --- src: !sourceDir!
	echo --- dest: !destDirFull!
	echo:

	REM create folder structure for destination
	IF NOT EXIST "!destDirFull!" ( mkdir "!destDirFull!" )

	IF /I "%backupType%" == "EVERYTHING" (
		robocopy "!sourceDir!\" "!destDirFull!\" /e /mt /is /it /tee /log:"!logDest!"
	)

	IF /I "%backupType%" == "MODIFIED" (
		robocopy "!sourceDir!\" "!destDirFull!\" /e /mt /m /tee /log:"!logDest!"
	)

	IF /I "%backupType%" == "MIRROR" (
		robocopy "!sourceDir!\" "!destDirFull!\" /e /mt /mir /tee /log:"!logDest!"
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
