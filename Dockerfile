###############
# Build Stage #
###############
FROM rust:latest as cargo-build

RUN apt-get update

RUN apt-get install musl-tools -y

WORKDIR /usr/src/rocket-test

COPY Cargo.toml Cargo.toml

RUN mkdir src/

COPY src src

RUN rustup default nightly

RUN rustup update && cargo update

RUN rustup target add x86_64-unknown-linux-musl

ENV RUSTFLAGS='-Clinker=musl-gcc'

RUN cargo build --release --target=x86_64-unknown-linux-musl

RUN rm -rf target/

###############
# Final Stage #
###############
FROM alpine:latest

COPY target/x86_64-unknown-linux-musl/release/rocket-test /usr/local/bin

CMD ["rocket-test"]
