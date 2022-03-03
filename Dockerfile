FROM debian:bullseye-slim

# env
ENV DEBIAN_FRONTEND=noninteractive \
    WGET_OPTIONS="--progress=bar:force:noscroll" \
    DOWNLOAD_ROOT_URL=https://github.com/oasisprotocol/oasis-core/releases/download \
    VERSION=21.3.9

RUN \
    \
# upgrade system and install prerequisites
    \
    apt-get update \
        && apt-get upgrade -y \
        && apt-get install -y --no-install-recommends \
            wget \
            ca-certificates \
    \
# download artifacts
    \
        && wget ${WGET_OPTIONS} ${DOWNLOAD_ROOT_URL}/v${VERSION}/oasis_core_${VERSION}_linux_amd64.tar.gz \
        && wget ${WGET_OPTIONS} ${DOWNLOAD_ROOT_URL}/v${VERSION}/SHA256SUMS-${VERSION}.txt \
    \
# verify checksum
    \
        && sha256sum -c SHA256SUMS-${VERSION}.txt \
        && tar xvf oasis_core_${VERSION}_linux_amd64.tar.gz \
    \
# copy binary to PATH and remove extra artifacts
    \
        && cp oasis_core_${VERSION}_linux_amd64/oasis-node /usr/local/bin \
        && rm -rf oasis_core_${VERSION}_linux_amd64* SHA256SUMS-${VERSION}.txt \
    \
# add oasis group and user
    \
        && groupadd -g 999 oasis \
        && useradd -M -r -u 999 -g 999 oasis \
    \
# cleanup
    \
        && apt-get remove -y --purge \
            wget \
            ca-certificates \
            openssl \
        && apt-get autoremove -y \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
    \
# fix oasis-node datadir permissions
    \
        && mkdir -p /node/data \
        && chown oasis:oasis /node/data \
        && chmod 0700 /node/data

# switch to oasis user
USER oasis

CMD ["oasis-node", "--config", "/node/etc/config.yml"]
