# checkov:skip=CKV_DOCKER_2:Healthcheck instructions have not been added to container images
FROM docker.io/alpine:3.20.3

LABEL org.opencontainers.image.vendor="Ministry of Justice" \
      org.opencontainers.image.authors="Analytical Platform" \
      org.opencontainers.image.title="kubectl Image" \
      org.opencontainers.image.description="kubectl image for Analytical Platform" \
      org.opencontainers.image.url="https://github.com/ministryofjustice/analytical-platform-kubectl"

ARG KUBECTL_VERSION="v1.29.6"

ENV CONTAINER_GID="10000" \
    CONTAINER_GROUP="nonroot" \
    CONTAINER_UID="10000" \
    CONTAINER_USER="nonroot" \
    CONTAINER_HOME="/app"

RUN addgroup \
      --gid ${CONTAINER_GID} \
      --system \
      ${CONTAINER_GROUP} \
    && adduser \
      --uid ${CONTAINER_UID} \
      --ingroup ${CONTAINER_GROUP} \
      --disabled-password \
      ${CONTAINER_USER} \
    && mkdir --parents ${CONTAINER_HOME} \
    && chown --recursive ${CONTAINER_USER}:${CONTAINER_GROUP} ${CONTAINER_HOME} \
    && apk add --no-cache --virtual build \
      curl==8.12.1-r0 \
    && curl --location "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
      --output /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/kubectl \
    && apk del build

USER ${CONTAINER_USER}

WORKDIR ${CONTAINER_HOME}
