FROM ubuntu:16.04

MAINTAINER tozastation <ryo.for.development@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
WORKDIR /tmp

# Add wget
RUN apt-get -y update
RUN apt-get -y install wget

# Add dotnet SDK
RUN wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get -y install apt-transport-https
RUN apt-get -y update
RUN apt-get -y install dotnet-sdk-2.2

# Add Mono
RUN apt-get -y install mono-devel

# Add Grpc protobuf-compiler
RUN apt-get -y install autoconf automake libtool curl make g++ unzip
RUN apt-get -y install git build-essential gettext cmake python
RUN apt-get -y install libprotobuf-dev libprotoc-dev 
RUN wget https://github.com/google/protobuf/releases/download/v3.2.0/protoc-3.2.0-linux-x86_64.zip
RUN unzip protoc-3.2.0-linux-x86_64.zip -d protoc3
RUN mv protoc3/bin/* /usr/local/bin/
RUN mv protoc3/include/* /usr/local/include/
RUN dotnet new console -o grpc; cd grpc; dotnet add package Grpc.Tools --version 1.19.0

# Grpc code setting
RUN mkdir grpc_model
RUN mkdir grpc_logic
ENV GRPC_PLUGIN_PATH=/root/.nuget/packages/grpc.tools/1.19.0/tools/linux_x64/grpc_csharp_plugin
ENV CSHARP_OUT_PATH=/tmp/grpc_model/.
ENV GRPC_OUT_PATH=/tmp/grpc_logic/.
ENV PROTO_PATH=/tmp/proto/
# Optional: change owner
# RUN chown root /usr/local/bin/protoc
# RUN chown -R [user] /usr/local/include/google

# Add Grpc Tool
# RUN dotnet add package Grpc.Tools
#RUN git clone https://github.com/grpc/grpc-web
#RUN cd grpc-web/; make install-plugin