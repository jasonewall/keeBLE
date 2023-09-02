FROM mcr.microsoft.com/devcontainers/rust:1.0.2-bullseye

RUN apt-get update \
    && apt-get install -y gcc-arm-none-eabi \
    && rustup target add thumbv7em-none-eabihf
