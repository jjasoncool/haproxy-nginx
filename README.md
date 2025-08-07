# HAProxy with Let's Encrypt Auto-Renewal using Docker

This project provides a Docker-based setup for running HAProxy as a reverse proxy with automatic SSL certificate issuance and renewal powered by Let's Encrypt (Certbot). It uses `supervisord` to manage processes within the container.

## Features

- **HAProxy**: A reliable and high-performance reverse proxy and load balancer.
- **Let's Encrypt**: Automatic issuance and renewal of SSL certificates via Certbot.
- **Supervisor**: Manages `haproxy` and `cron` processes within a single container.
- **Cron Automation**:
  - Periodically checks and renews SSL certificates.
  - Copies essential logs from the container to the host for easy access and persistence.
- **Persistent Storage**: Configurations, certificates, and logs are stored on the host using Docker volumes.

## Directory Structure

```
.
├── certs/
│   └── # Persisted Let's Encrypt certificates will be stored here.
├── config/
│   └── # Persisted application configurations can be stored here.
├── haproxy/
│   ├── cert-list.cfg.template  # Template for the domain list for SSL certificates.
│   ├── copy-logs.sh            # Script to copy important logs from the container to the host.
│   ├── dockerfile              # Defines the HAProxy container image.
│   ├── haproxy.cfg             # The main HAProxy configuration file.
│   ├── le-renew-haproxy        # The script that handles certificate renewal.
│   └── supervisord.conf        # Configuration for Supervisor process manager.
├── logs/
│   └── # Key logs from the container are copied here.
├── nginx/
│   ├── default.conf.template   # Template for Nginx default server block.
│   ├── dockerfile              # Dockerfile for a potential Nginx service.
│   └── nginx.conf              # Main Nginx configuration file.
├── .env.template               # Template for environment variables.
├── .gitignore                  # Specifies files for Git to ignore.
├── docker-compose.yaml         # Orchestrates the deployment of the service.
└── README.md                   # This documentation file.
```

## Getting Started

Follow these steps to get your reverse proxy up and running.

### 1. Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

### 2. Initial Configuration

First, create the directories needed for persistent storage. Since these empty directories are not stored in Git, you must create them manually.

```bash
mkdir -p ./certs ./logs ./config
```

Next, prepare the necessary configuration files from the templates.

```bash
# Copy the environment file
cp .env.template .env

# Copy the certificate list for HAProxy
cp haproxy/cert-list.cfg.template haproxy/cert-list.cfg
```

### 3. Customize Your Configuration

- **`.env`**: Edit this file to set the `HA_VERSION` (the HAProxy version you want to use).
- **`haproxy/cert-list.cfg`**: **This is a critical step.** Edit this file and list the domain names for which you want to obtain SSL certificates. The format should be `/etc/haproxy/certs/your-domain.com.pem`. Add one domain per line.
- **`haproxy/haproxy.cfg`**: Customize the main HAProxy configuration file to define your frontend and backend services.

### 4. Build and Run the Container

Once you have completed the configuration, build and start the service in detached mode.

```bash
docker-compose up -d --build
```

The container will start, and Certbot will attempt to obtain certificates for the domains you listed.

## How It Works

- **`docker-compose`**: Starts the `haproxy` service defined in `docker-compose.yaml`.
- **`supervisord`**: Inside the container, `supervisord` is the main process. It starts and monitors:
  - The `haproxy` process.
  - The `cron` daemon.
- **`cron`**: Two scheduled jobs are configured:
  1.  **Certificate Renewal**: Runs the `/usr/local/sbin/le-renew-haproxy` script weekly to check and renew certificates.
  2.  **Log Copying**: Runs the `/usr/local/sbin/copy-logs.sh` script daily to copy key log files to the `./logs` directory on the host.

## Logging

Key logs are copied from the container to the `./logs` directory on the host for easy access.

- **`./logs/cron.log`**: Output from the certificate renewal script. Check this file for renewal successes or failures.
- **`./logs/supervisord/supervisord.log`**: The main log for the supervisor process. Useful for debugging issues with `haproxy` or `cron` not starting correctly.
- **`./logs/letsencrypt/letsencrypt.log`**: Detailed logs from Certbot.

To view real-time logs from the container, you can use:
```bash
docker-compose logs -f
```

## Development

### Testing the `sed` command

To test the `sed` command used in the Dockerfile for parsing domains without a full build:
```bash
docker build -t test -f ./haproxy/test_sed ./haproxy && docker run --rm test
