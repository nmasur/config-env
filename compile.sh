#!/bin/sh

cargo build \
      --release \
      --target x86_64-unknown-linux-musl \
    && cargo pkgid \
        | cut -d# -f2 \
        | cut -d: -f2 \
              > ./target/x86_64-unknown-linux-musl/release/VERSION
