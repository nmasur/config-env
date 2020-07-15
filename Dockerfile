FROM rust:1.44-alpine

RUN apk add musl-dev openssl-dev \
  && rustup target add x86_64-unknown-linux-musl

COPY . ./

CMD cargo build --release --target x86_64-unknown-linux-musl
