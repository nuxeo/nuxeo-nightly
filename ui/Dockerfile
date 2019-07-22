ARG DOCKER_REGISTRY
ARG NUXEO_WEBUI_VERSION
FROM ${DOCKER_REGISTRY}/nuxeo/nuxeo-web-ui/dev:${NUXEO_WEBUI_VERSION} AS builder

# WORKDIR /ui

# copy project files
# COPY . ./addons/nsilva-SANDBOX

ARG NUXEO_PACKAGES
RUN npm run build

FROM ${DOCKER_REGISTRY}/nuxeo/nuxeo-web-ui/server:${NUXEO_WEBUI_VERSION}

COPY --from=builder /ui/dist/ ui/
