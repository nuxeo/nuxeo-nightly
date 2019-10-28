ARG NUXEO_WEBUI_VERSION
FROM docker.packages.nuxeo.com/nuxeo/nuxeo-web-ui/dev:${NUXEO_WEBUI_VERSION} AS builder

WORKDIR /ui

# copy project files
COPY ./addons/ ./addons/

ARG NUXEO_PACKAGES
RUN npm run build

FROM docker.packages.nuxeo.com/nuxeo/nuxeo-web-ui/server:${NUXEO_WEBUI_VERSION}

COPY --from=builder /ui/dist/ ui/
