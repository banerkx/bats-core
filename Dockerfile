ARG bashver=latest

FROM bash:${bashver}
HEALTHCHECK NONE
ARG TINI_VERSION=v0.19.0
ARG TARGETPLATFORM
ARG LIBS_VER_SUPPORT=0.3.0
ARG LIBS_VER_FILE=0.4.0
ARG LIBS_VER_ASSERT=2.1.0
ARG LIBS_VER_DETIK=1.3.2
ARG UID=1001
ARG GID=115

# https://github.com/opencontainers/image-spec/blob/main/annotations.md
LABEL maintainer="Bats-core Team"
LABEL org.opencontainers.image.authors="Bats-core Team"
LABEL org.opencontainers.image.title="Bats"
LABEL org.opencontainers.image.description="Bash Automated Testing System"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/bats/bats"
LABEL org.opencontainers.image.source="https://github.com/bats-core/bats-core"
LABEL org.opencontainers.image.base.name="docker.io/bash"

COPY ./docker /tmp/docker
# default to amd64 when not running in buildx environment that provides target platform
RUN /tmp/docker/install_tini.sh "${TARGETPLATFORM-linux/amd64}"
# Install bats libs
RUN /tmp/docker/install_libs.sh support ${LIBS_VER_SUPPORT} \
&& /tmp/docker/install_libs.sh file ${LIBS_VER_FILE}        \
&& /tmp/docker/install_libs.sh assert ${LIBS_VER_ASSERT}    \
&& /tmp/docker/install_libs.sh detik ${LIBS_VER_DETIK}

# Install parallel and accept the citation notice (we aren't using this in a
# context where it makes sense to cite GNU Parallel).
ARG parallel_version=latest
ARG ncurses_version=latest
RUN apk add --no-cache parallel=${parallel_version} ncurses=${ncurses_version} && \
mkdir -p ~/.parallel && touch ~/.parallel/will-cite \
&& mkdir /code

RUN ln -s "$(/usr/bin/env which bash)" "/bin/bash"

RUN ln -s /opt/bats/bin/bats /usr/local/bin/bats
COPY . /opt/bats/

WORKDIR /code/

ENTRYPOINT ["/tini", "--", "/usr/local/bin/bash", "/usr/local/bin/bats"]
