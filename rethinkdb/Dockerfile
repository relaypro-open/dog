FROM rethinkdb:latest

# Install python3 and pip to install rethinkdb CLI tools (required for 'rethinkdb admin')
RUN apt-get update && \
    apt-get install -y --no-install-recommends python3-pip python3-setuptools && \
    rm -rf /var/lib/apt/lists/*

# Install rethinkdb python driver which provides the 'rethinkdb' CLI utility
RUN pip3 install --no-cache-dir rethinkdb --break-system-packages

# Copy the entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Use the entrypoint script to create the database on startup
ENTRYPOINT ["entrypoint.sh"]

# Default command to pass to the entrypoint
CMD ["--bind", "all"]
