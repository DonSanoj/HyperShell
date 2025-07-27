@echo off
"C:\Program Files\Git\bin\bash.exe" --login -i "C:\Users\DON\Documents\Working Projects\HyperShell\HyperShell.sh"

if %errorlevel% neq 0 (
    echo An error occurred while launching the HyperShell.
    exit /b %errorlevel%
)

pause