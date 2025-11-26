# Hugo with lots of tooling (Debian-based CI image)
FROM docker.io/hugomods/hugo:debian-ci

# Install dependencies for GitHub Actions runner + rsync
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl \
      ca-certificates \
      git \
      rsync \
      bash \
      jq \
    && rm -rf /var/lib/apt/lists/*

# Version of the GitHub Actions runner to install
ARG GH_RUNNER_VERSION=2.321.0
ENV GH_RUNNER_VERSION=${GH_RUNNER_VERSION}

# Where the Actions runner will live
WORKDIR /actions-runner

# Download and install the GitHub Actions runner
RUN set -eux; \
    ARCH="$(uname -m)"; \
    case "$ARCH" in \
      x86_64) RUNNER_ARCH="x64" ;; \
      aarch64|arm64) RUNNER_ARCH="arm64" ;; \
      *) echo "Unsupported architecture: $ARCH" >&2; exit 1 ;; \
    esac; \
    curl -L "https://github.com/actions/runner/releases/download/v${GH_RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${GH_RUNNER_VERSION}.tar.gz" \
      -o actions-runner.tar.gz; \
    tar xzf actions-runner.tar.gz; \
    rm actions-runner.tar.gz; \
    ./bin/installdependencies.sh

# Directory where the generated Hugo site will be placed and bind-mounted
ENV HUGO_DEST=/site
RUN mkdir -p "${HUGO_DEST}"

# Expose /site as a volume (you'll bind-mount this from the host)
VOLUME ["/site"]

# Default runner settings
ENV RUNNER_WORKDIR=_work
ENV GH_RUNNER_NAME=""
ENV GH_RUNNER_LABELS="self-hosted,hugo"

# Entrypoint script will:
#  - Register the GitHub runner using GH_RUNNER_URL + GH_RUNNER_TOKEN
#  - Start the runner
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
