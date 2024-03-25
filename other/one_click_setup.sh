#!/bin/bash

# Check if Python is installed
if ! command -v python3 &> /dev/null
then
    echo "Python is not installed on this computer."
    exit 1
fi

# Set the repository URL
REPOURL="https://github.com/Andy-Wu25/Systems-Engineering.git"

# Clone the repository
echo "Cloning repository."
echo $REPOURL
git clone $REPOURL

# Wait for 3 seconds
sleep 3

# Clear the screen

# Downloading necessary model files using aria2c
echo "Downloading necessary model files..."
if [ ! -d _temporary_ ]; then
    mkdir _temporary_
fi

sudo apt install aria2

# Replace 'http://example.com/file1.zip' with the actual URL of the file you want to download
if [ ! -f _temporary_/vallex-checkpoint.pt ]; then
    aria2c https://huggingface.co/Plachta/VALL-E-X/resolve/main/vallex-checkpoint.pt --dir=_temporary_/ --out=vallex-checkpoint.pt
fi

if [ ! -f _temporary_/medium.pt ]; then
    aria2c -s16 -x16 https://openaipublic.azureedge.net/main/whisper/models/345ae4da62f9b3d59415adc60127b97c714f32e89e936602e85993674d08dcb1/medium.pt --dir=_temporary_/ --out=medium.pt
fi

if [ ! -d "Systems-Engineering/VALL/checkpoints" ]; then
    mkdir -p "Systems-Engineering/VALL/checkpoints"
    mv "_temporary_/vallex-checkpoint.pt" "Systems-Engineering/VALL/checkpoints/"
fi

if [ ! -d "Systems-Engineering/VALL/whisper" ]; then
    mkdir -p "Systems-Engineering/VALL/whisper"
    mv "_temporary_/medium.pt" "Systems-Engineering/VALL/whisper/"
fi

echo "Downloading and setting up model files completed. Removing temporary directory"
# rm -r "_temporary_ "

sleep 3

echo "Installing Python virtual environment"
sudo apt install python3.10-venv

echo "Installation completed, creating virtual environment"
python3 -m venv "Systems-Engineering/.venv"

echo "Virtual environment created, installing runtime dependencies."
"Systems-Engineering/.venv/bin/pip3" install -r "Systems-Engineering/requirements.txt"

read -p "Environment setup finished."
