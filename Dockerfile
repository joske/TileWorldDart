FROM ubuntu:focal

ENV DEBIAN_FRONTEND noninteractive

RUN apt update
RUN apt-get install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libgcrypt-dev mesa-utils libgl1-mesa-glx

RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

# Download Flutter SDK
RUN git clone https://github.com/flutter/flutter.git
ENV PATH "$PATH:/home/developer/flutter/bin"

RUN flutter config --enable-linux-desktop

COPY --chown=developer:developer pubspec.yaml .
RUN flutter pub get

COPY --chown=developer:developer . .

CMD ["flutter", "run"]


