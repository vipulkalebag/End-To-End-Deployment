# because of dotnet, we always build on amd64, and target platforms in cli
# dotnet doesn't support QEMU for building or running. 
# (errors common in arm/v7 32bit) https://github.com/dotnet/dotnet-docker/issues/1537
# https://hub.docker.com/_/microsoft-dotnet
# hadolint ignore=DL3029
# to build for a different platform than your host, use --platform=<platform>
# for example, if you were on Intel (amd64) and wanted to build for ARM, you would use:
# docker buildx build --platform "linux/arm64/v8" .

# build compiles the program for the builder's local platform
# FROM --platform=${BUILDPLATFORM} mcr.microsoft.com/dotnet/sdk:7.0 AS build
# ARG TARGETPLATFORM
# ARG TARGETARCH
# ARG BUILDPLATFORM
# RUN echo "I am running on $BUILDPLATFORM, building for $TARGETPLATFORM"

# WORKDIR /source
# COPY *.csproj .
# RUN dotnet restore -a $TARGETARCH

# COPY . .
# RUN dotnet publish -c release -o /app -a $TARGETARCH --self-contained false --no-restore

# # app image
# FROM mcr.microsoft.com/dotnet/runtime:7.0
# WORKDIR /app
# COPY --from=build /app .
# ENTRYPOINT ["dotnet", "Worker.dll"]

# Build stage
# Build stage
FROM --platform=${BUILDPLATFORM:-linux/amd64} mcr.microsoft.com/dotnet/sdk:7.0 AS build

# Build arguments with default values
ARG BUILDPLATFORM=linux/amd64
ARG TARGETPLATFORM=linux/amd64
ARG TARGETARCH=amd64

RUN echo "Running on platform: $BUILDPLATFORM, building for $TARGETPLATFORM, architecture: $TARGETARCH"

WORKDIR /source

# Copy project file and restore dependencies
COPY *.csproj ./
RUN dotnet restore --arch $TARGETARCH

# Copy source files and publish the app
COPY . ./
RUN dotnet publish -c Release -o /app --arch $TARGETARCH --self-contained false --no-restore

# App image stage
FROM mcr.microsoft.com/dotnet/runtime:7.0

WORKDIR /app

# Copy published files from the build stage
COPY --from=build /app ./

# Define the entry point for the application
ENTRYPOINT ["dotnet", "Worker.dll"]
