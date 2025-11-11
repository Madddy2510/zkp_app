### ZKP gRPC client/server for authentication

This project implements a Zero-Knowledge Proof (ZKP) based authentication system using Rust and gRPC (tonic + prost).
It provides a simple example of privacy-preserving authentication between a client and a server.

##Project Overview

What is a Zero-Knowledge Proof (ZKP)?

A Zero-Knowledge Proof allows one party (the client) to prove to another party (the server) that it knows a secret (like a password or private key) without ever revealing the secret itself.

This concept is useful for secure authentication — it prevents sensitive data (like passwords or private keys) from being transmitted or stored insecurely.

#How this project works

This implementation uses a simplified Chaum-Pedersen proof to demonstrate the authentication process:

#Registration Phase

The client generates public keys based on its secret and sends them to the server for registration.

#Authentication Challenge

The server sends a random challenge to the client.

#Proof Verification

The client uses its secret to compute a proof that satisfies the challenge.

The server verifies the proof mathematically, without ever seeing the client’s secret.

Both communication and serialization are handled using gRPC and Protocol Buffers.

##Docker Implementation

This project uses Docker for complete environment encapsulation.
All dependencies (Rust, protobuf compiler, and gRPC tools) are included in the Docker build.

#Architecture

#zkp_server container

Hosts the gRPC authentication server on port 50051.

Handles registration, challenge creation, and proof verification.

#zkp_client container

Runs the client-side logic to perform registration and authentication.

Communicates with the server container via Docker’s internal network.

Both containers run together using a Docker Compose network named zkp_net, allowing them to communicate by hostname (the client connects to zkp_server:50051).

The project includes two services:

zkp_server — Handles registration, challenge generation, and verification.

zkp_client — Performs registration and authentication using ZKP.

Both services are containerized using Docker and managed with Docker Compose.

1. Install Dependencies

Before you begin, make sure your system has the following installed.

Required:

Docker

Docker Compose

Optional (for local Rust builds):
You need Rust and the protobuf-compiler. For Linux:

<pre><code>sudo apt update sudo apt install -y protobuf-compiler </code></pre>

Verify installation:

<pre><code>rustc --version protoc --version </code></pre>
2. Clone the Repository
<pre><code>git clone https://github.com/Madddy2510/zkp_app.git cd zkp_app </code></pre>
3. Run Using Pre-Built Docker Images (Recommended)
<pre><code>docker login docker compose up </code></pre>

Docker automatically pulls:

madmax122333/zkp_server:latest

madmax122333/zkp_client:latest

Stop containers:

<pre><code>docker compose down </code></pre>
4. Build and Run Locally

If you want to build from source:

<pre><code>docker compose build docker compose up </code></pre>

Clean up:

<pre><code>docker compose down </code></pre>
5. Run Without Docker (Optional)

For Rust developers:

<pre><code>cargo build --release cargo run --release --bin server cargo run --release --bin client </code></pre>

The server listens on 0.0.0.0:50051, and the client connects to it for authentication.

6. Updating and Pushing Docker Images (For Maintainers)
<pre><code>docker compose build docker tag zkp_server madmax122333/zkp_server:latest docker tag zkp_client madmax122333/zkp_client:latest docker push madmax122333/zkp_server:latest docker push madmax122333/zkp_client:latest </code></pre>

7. Project Structure
.
├── Cargo.toml
├── Dockerfile
├── docker-compose.yml
├── proto/
│   └── zkp_auth.proto
└── src/
    ├── lib.rs
    ├── server.rs
    └── client.rs
8. Networking Details
<pre><code>docker network ls docker network inspect zkp_app_zkp_net </code></pre>
9. Troubleshooting

Connection refused → Ensure both containers are running and server binds to 0.0.0.0.

Missing protoc → Install:

<pre><code>sudo apt install protobuf-compiler </code></pre>

Re-run client manually:

<pre><code>docker compose run --rm zkp_client </code></pre>
