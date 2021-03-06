FROM ubuntu:16.04
MAINTAINER Wataru Mukainakano

# Upgrade software
RUN apt-get update -y && apt-get upgrade -y

# Git installation
RUN apt-get install -y git

# Open JDK8 installation
RUN \
  apt-get install -y software-properties-common curl && \
  add-apt-repository -y ppa:openjdk-r/ppa && \
  apt-get update && \
  apt-get install -y openjdk-8-jdk
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

# Android SDK Installation
ENV ANDROID_SDK_REVISION r24.4.1
RUN \
  cd /usr/local && \
  curl -L -O "https://dl.google.com/android/android-sdk_$ANDROID_SDK_REVISION-linux.tgz" && \
  tar -xf "android-sdk_$ANDROID_SDK_REVISION-linux.tgz" && \
  rm "/usr/local/android-sdk_$ANDROID_SDK_REVISION-linux.tgz" && \
  chown -R root:root /usr/local
RUN apt-get install -y lib32z1 lib32gcc1

ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV PATH $PATH:$ANDROID_HOME/tools
ENV PATH $PATH:$ANDROID_HOME/platform-tools

RUN echo y | android update sdk --no-ui --force --all --filter "tools"
RUN echo y | android update sdk --no-ui --force --all --filter "platform-tools"
RUN echo y | android update sdk --no-ui --force --all --filter "build-tools-25.0.3"
RUN echo y | android update sdk --no-ui --force --all --filter "android-25"
RUN echo y | android update sdk --no-ui --force --all --filter "extra-android-m2repository,extra-google-google_play_services,extra-google-m2repository"

# Ruby installation
RUN add-apt-repository -y ppa:brightbox/ruby-ng && apt-get update && apt-get install -y ruby2.3 ruby2.3-dev build-essential
RUN gem install bundler -v 1.12 --no-ri --no-rdoc

# Go installation
ENV GO_VERSION 1.8.3
RUN \
  cd /usr/local && \
  curl -L -O "https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz" && \
  tar -xzf go$GO_VERSION.linux-amd64.tar.gz && \
  rm "/usr/local/go$GO_VERSION.linux-amd64.tar.gz" && \
  chown -R root:root /usr/local/go
ENV GO_HOME /usr/local/go
ENV PATH $PATH:$PATH:$GO_HOME/bin
