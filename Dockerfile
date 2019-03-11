FROM ubuntu:16.04

WORKDIR /tmp

# Add wget
RUN apt-get -y update && apt-get -y install wget && apt-get install -y unzip

# Add dotnet SDK
RUN wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get -y install apt-transport-https
RUN apt-get -y update && apt-get install -y dotnet-sdk-2.2

# Add Mono
RUN apt-get -y install mono-devel

# Add Grpc protobuf-compiler
RUN wget https://github.com/google/protobuf/releases/download/v3.2.0/protoc-3.2.0-linux-x86_64.zip && \ 
    unzip protoc-3.2.0-linux-x86_64.zip -d protoc3
RUN mv protoc3/bin/* /usr/local/bin/ && mv protoc3/include/* /usr/local/include/ && rm -rf protoc3
RUN dotnet new console -o grpc; cd grpc; dotnet add package Grpc.Tools --version 1.19.0

# Grpc code setting
ENV GRPC_PLUGIN_PATH=/root/.nuget/packages/grpc.tools/1.19.0/tools/linux_x64/grpc_csharp_plugin
ENV CSHARP_OUT_PATH=/tmp/grpc/model/.
ENV GRPC_OUT_PATH=/tmp/grpc/logic/.
ENV PROTO_PATH=/tmp/grpc/idl/

# Clean Cache
RUN apt-get autoclean
RUN apt-get autoremove