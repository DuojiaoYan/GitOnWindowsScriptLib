@echo off
@setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
@IF ERRORLEVEL 1 (
	@echo Unable to enable extensions.
	@goto :EOF
)
@if "%1"=="" @goto :USAGE
@set DependenciesFile=%1
@if "%2"=="" (
	@set TargetDir=%CD%
) else (
	@set TargetDir=%2
)
@if NOT EXIST "%TargetDir%" @md "%TargetDir%"
@set /A count=0
@for /f "tokens=1* delims=-" %%I in (%DependenciesFile%) do @(
	@if "%%J"== "" (
		@xcopy "%%I" "%TargetDir%" /I /V /R /Y >nul
		@for /R "%TargetDir%" %%F in (%%~nxI) do (
			@set /A count+=1
			@echo File !count!: %%~nxF copied.
		)
	) else (
		@xcopy "%%I-%%J" "%TargetDir%" /I /V /R /Y >nul
		@xcopy "%%I??-%%J" "%TargetDir%" /I /V /R /Y >nul
		@for /R "%TargetDir%" %%F in (%%~nI*-%%J) do (
			@set /A count+=1
			@echo File !count!: %%~nxF copied.
		)
	)
)
@if '!count!'=='0' (
	@echo No files copied.
) else (
	@echo !count! files copied totally.
)
@endlocal
@goto :END
:USAGE
@echo Copies all the dependency files spedified in a file.
@echo.
@echo Usage:
@echo.
@echo     %0 dependenciesListFile [destinationDirectory]
@echo.
@echo Description:
@echo.
@echo     dependenciesListFile 
@echo         Requried. The file contains all the dependencies.
@echo.
@echo     destinationDirectory 
@echo         Optional. The target directory that all the dependencies will be copied to. If this value is not specified, use current directory as destination folder instead.
@echo. 
@echo Example:
@echo.
@echo     %0 git_dependencies.txt git_dependencies
:END
@echo on