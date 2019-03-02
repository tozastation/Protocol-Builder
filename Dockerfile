FROM mcr.microsoft.com/dotnet/core/sdk:2.2-alpine

WORKDIR /tmp

# Add wget
RUN apk update 
RUN apk add wget

# Add Protocol Compiler
RUN apk add alpine-sdk
# RUN wget https://github.com/google/protobuf/releases/download/v3.2.0/protoc-3.2.0-linux-x86_64.zip
# RUN mkdir protoc3
# RUN unzip protoc-3.2.0-linux-x86_64.zip -d protoc3
# RUN mv protoc3/bin/* /usr/local/bin/
# RUN mv protoc3/include/* /usr/local/include/
RUN apk add protobuf
RUN dotnet new console -o grpc; cd grpc; dotnet add package Grpc.Tools --version 1.19.0

# Grpc code setting
ENV GRPC_PLUGIN_PATH=/root/.nuget/packages/grpc.tools/1.19.0/tools/linux_x86/grpc_csharp_plugin
ENV CSHARP_OUT_PATH=/tmp/grpc/model/.
ENV GRPC_OUT_PATH=/tmp/grpc/logic/.
ENV PROTO_PATH=/tmp/grpc/idl/