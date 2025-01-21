# Use the official Rust image to build the project
FROM rust:latest as builder

# Install boringtun-cli using cargo
RUN cargo install boringtun-cli

# Use a minimal base image
FROM debian:bookworm-slim

# Copy the built binary from the builder stage
COPY --from=builder /usr/local/cargo/bin/boringtun-cli /usr/local/bin/boringtun

# Install dependencies
RUN apt-get update && \
    apt-get install -y iproute2 wireguard-tools iputils-ping iptables && \
    apt-get clean

# Set environment variables for wg-quick
ENV WG_QUICK_USERSPACE_IMPLEMENTATION=boringtun
ENV WG_SUDO=1

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Command to run the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
