# Use TensorFlow 1.15.4 with GPU and Python 3
FROM tensorflow/tensorflow:1.15.4-gpu-py3

RUN rm /etc/apt/sources.list.d/cuda.list
RUN rm /etc/apt/sources.list.d/nvidia-ml.list

# Update the package list
RUN apt-get update

# Install DeepSpeech GPU version
RUN pip3 install deepspeech-gpu

# Install Git
RUN apt-get install -y git

# Clone the DeepSpeech repository at a specific version
RUN git clone --branch v0.9.3 https://github.com/mozilla/DeepSpeech

# Change the working directory to DeepSpeech
WORKDIR /DeepSpeech

# Upgrade pip, wheel, and setuptools to specific versions
RUN pip3 install --upgrade pip==20.2.2 wheel==0.34.2 setuptools==49.6.0

# Install the DeepSpeech package in editable mode
RUN pip3 install --upgrade -e .

# Install Sox and MP3 support for Sox
RUN apt-get install -y sox libsox-fmt-mp3

# Install Python 3 development package
RUN apt-get install -y python3-dev

# Install nano
RUN apt-get install nano

# Create a directory for recordings
RUN mkdir -p /DeepSpeech/data/recordings

# Set the image name
LABEL image=deepspeech-image