FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -y git gcc make openssl python3 libssl-dev libbz2-dev libreadline-dev libsqlite3-dev
RUN git clone https://github.com/yyuu/pyenv.git /root/.pyenv
RUN apt-get install -y curl
RUN apt-get install -y pkg-config zip g++ zlib1g-dev unzip python
# https://github.com/bazelbuild/bazel/releases
#ADD https://github.com/bazelbuild/bazel/releases/download/0.15.0/bazel_0.15.0-linux-x86_64.deb /root/
ADD bazel_0.15.0-linux-x86_64.deb /root/
RUN apt-get install -y openjdk-8-jdk
RUN apt-get install -y bash-completion
ARG PYTHON_VERSION="3.7.0"
RUN dpkg -i /root/bazel_0.15.0-linux-x86_64.deb
RUN apt-get install -y libffi-dev build-essential
RUN /root/.pyenv/bin/pyenv install ${PYTHON_VERSION}
WORKDIR /root/
RUN /root/.pyenv/bin/pyenv local ${PYTHON_VERSION}
RUN /root/.pyenv/shims/pip install six numpy wheel 
