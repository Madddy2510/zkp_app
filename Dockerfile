# 1. Build Stage
FROM rust:1.82 AS builder

# Install protobuf compiler
RUN apt-get update && apt-get install -y protobuf-compiler && apt-get clean

WORKDIR /app

# Copy manifest files first for caching
COPY Cargo.toml Cargo.lock ./

# Copy source and proto files
COPY src ./src
COPY proto ./proto
COPY build.rs ./

# Build all binaries
RUN cargo build --release

# 2. Runtime Stage
FROM debian:bookworm-slim AS runtime

# Install dependencies
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy both binaries from builder
COPY --from=builder /app/target/release/server /usr/local/bin/zkp_server
COPY --from=builder /app/target/release/client /usr/local/bin/zkp_client

# Expose the port the server listens on
EXPOSE 8080

# Default command (used by docker run)
CMD ["/usr/local/bin/zkp_server"]

