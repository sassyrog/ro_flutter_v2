FROM mcr.microsoft.com/devcontainers/base:debian

ARG USER=vscode
ARG USER_HOME=/home/${USER}

# Install linux dependencies
RUN apt-get update && \
    apt-get install -y \
    clang \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev && \
    apt dist-upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Get latest Android SDK
ENV ANDROID_HOME=/opt/android-sdk-linux
ENV ANDROID_SDK_ROOT=$ANDROID_HOME
COPY --from=mobiledevops/android-sdk-image $ANDROID_HOME $ANDROID_HOME
RUN mkdir -p $ANDROID_HOME/cmdline-tools/latest && \
    (cd $ANDROID_HOME/cmdline-tools && ls | grep -v latest | xargs mv -t latest) && \
    chown -R ${USER}:${USER} $ANDROID_HOME
ENV PATH="${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${PATH}"

# Get latest Java SDK
ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:latest $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"
RUN chown -R ${USER}:${USER} $JAVA_HOME

# Get latest Flutter
ENV FLUTTER_HOME=/usr/bin/flutter
RUN mkdir -p $FLUTTER_HOME && \
    git clone -b stable https://github.com/flutter/flutter $FLUTTER_HOME && \
    chown -R ${USER}:${USER} $FLUTTER_HOME
ENV PATH="${FLUTTER_HOME}/bin:${PATH}"

# Create and configure Gradle directory and Flutter cache directories
RUN mkdir -p ${USER_HOME}/.gradle && \
    chown -R ${USER}:${USER} ${USER_HOME}/.gradle && \
    mkdir -p ${USER_HOME}/.pub-cache && \
    mkdir -p ${USER_HOME}/.pub-cache/hosted && \
    mkdir -p ${USER_HOME}/.pub-cache/hosted-hashes && \
    chown -R ${USER}:${USER} ${USER_HOME}/.pub-cache && \
    chmod -R 777 ${USER_HOME}/.pub-cache

# Switch to non-root user for Flutter operations
USER ${USER}

# Configure and verify Flutter installation
RUN git config --global --add safe.directory '*' && \
    flutter doctor && \
    flutter precache --android --web --ios && \
    echo 'source <(flutter bash-completion)' >> ~/.bashrc && \
    sdkmanager --version && \
    java --version && \
    dart --disable-analytics && \
    flutter config --no-analytics