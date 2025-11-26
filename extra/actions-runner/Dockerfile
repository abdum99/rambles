FROM docker.io/hugomods/hugo:debian-ci

# Install deps as root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      curl \
      ca-certificates \
      git \
      rsync \
      bash \
      jq \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user for the GitHub runner
RUN useradd -m -s /bin/bash runner

# GitHub runner version
ARG GH_RUNNER_VERSION=2.321.0
ENV GH_RUNNER_VERSION=${GH_RUNNER_VERSION}

# Runner location
WORKDIR /actions-runner

# Download GitHub Actions runner as root
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

# Volume for Hugo output
ENV HUGO_DEST=/site
RUN mkdir -p "${HUGO_DEST}" && chown runner:runner "${HUGO_DEST}"

VOLUME ["/site"]

# Give runner ownership of its files
RUN chown -R runner:runner /actions-runner

# Switch to non-root user
USER runner

# Default runner config
ENV RUNNER_WORKDIR=_work
ENV GH_RUNNER_NAME=""
ENV GH_RUNNER_LABELS="self-hosted,hugo"

# Entrypoint
COPY --chown=runner:runner entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
