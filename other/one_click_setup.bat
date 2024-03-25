@echo off

python --version >nul 2>&1

if %ERRORLEVEL% neq 0 (
    echo "Python is not installed on this computer."
    pause
    exit /b
) else (
    setlocal enabledelayedexpansion

    set REPOURL="https://github.com/Andy-Wu25/Systems-Engineering.git"
    echo "Cloning repository."
    echo !REPOURL!
    git clone !REPOURL!
    
    timeout /t 3 /nobreak >nul

    cls

    echo Downloading necessary model files...
    set TEMPORARY_DIRECTORY=_temporary_
    if not exist !TEMPORARY_DIRECTORY! (
        mkdir !TEMPORARY_DIRECTORY!
    )
    powershell -Command "Invoke-WebRequest -Uri 'https://github.com/aria2/aria2/releases/download/release-1.37.0/aria2-1.37.0-win-64bit-build1.zip' -OutFile 'aria2-1.37.0-win-64bit-build1.zip' -Verbose
    powershell -Command "Expand-Archive -Force aria2-1.37.0-win-64bit-build1.zip"
    del aria2-1.37.0-win-64bit-build1.zip
    if not exist !TEMPORARY_DIRECTORY!/vallex-checkpoint.pt (
        powershell -Command "aria2-1.37.0-win-64bit-build1\aria2-1.37.0-win-64bit-build1\aria2c.exe https://huggingface.co/Plachta/VALL-E-X/resolve/main/vallex-checkpoint.pt --dir=!TEMPORARY_DIRECTORY!/ --out=vallex-checkpoint.pt"
    )
    if not exist !TEMPORARY_DIRECTORY!/medium.pt (
            powershell -Command "aria2-1.37.0-win-64bit-build1\aria2-1.37.0-win-64bit-build1\aria2c.exe -s16 -x16 https://openaipublic.azureedge.net/main/whisper/models/345ae4da62f9b3d59415adc60127b97c714f32e89e936602e85993674d08dcb1/medium.pt --dir=!TEMPORARY_DIRECTORY!/ --out=medium.pt"
    )
    powershell -Command "Remove-Item -Force -Path aria2-1.37.0-win-64bit-build1 -Recurse"
    if not exist "Systems-Engineering/VALL/checkpoints" (
        mkdir "Systems-Engineering/VALL/checkpoints"
    )
    powershell -Command  "move !TEMPORARY_DIRECTORY!/vallex-checkpoint.pt Systems-Engineering/VALL/checkpoints/"
    if not exist "Systems-Engineering/VALL/whisper" (
        mkdir "Systems-Engineering/VALL/whisper"
    )
    powershell -Command  "move !TEMPORARY_DIRECTORY!/medium.pt Systems-Engineering/VALL/whisper/"
    echo Downloading and setting up model files completed. Removing temporary directory
    pause
    rmdir !TEMPORARY_DIRECTORY!

    timeout /t 3 /nobreak >nul

    cls

    echo Installing Python virtual environment
    pip install virtualenv
    
    echo Installation completed, creating virtual environment
    python -m venv "Systems-Engineering/.venv"

    echo Virtual environment created, installing runtime dependencies.
    powershell -Command "Systems-Engineering/.venv/Scripts/pip3.exe install -r Systems-Engineering/requirements.txt"

    pause
)