@for /F "usebackq tokens=3 " %%i in (`gethttpproxy.bat`) do @echo %%i
