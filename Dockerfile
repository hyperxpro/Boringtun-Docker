FROM alpine:latest AS build

RUN \
 echo "***** install cargo ****" && \
 apk add cargo && \
 echo "***** install boringtun via cargo ****" && \
 cargo install boringtun-cli 

FROM alpine:latest

# add local files
COPY --from=build /root/.cargo/bin/boringtun-cli /data/boringtun

RUN \
 echo "***** install ip mgmt tools *****" && \
 apk add --no-cache wireguard-tools iproute2 libgcc && \
 echo "**** cleanup ****" && \
 rm -rf /tmp/* /var/tmp/*

# Set environment variables for wg-quick
ENV WG_QUICK_USERSPACE_IMPLEMENTATION=boringtun
ENV WG_SUDO=1

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Command to run the entrypoint script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
