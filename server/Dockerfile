ARG NUXEO_PLATFORM_VERSION

FROM docker.packages.nuxeo.com/nuxeo/builder:$NUXEO_PLATFORM_VERSION as builder

COPY packages /packages
RUN install-packages.sh /packages

# Copy addons
COPY addons/* /distrib/nxserver/bundles

# Target stage
FROM docker.packages.nuxeo.com/nuxeo/base:$NUXEO_PLATFORM_VERSION
LABEL maintainer="Nuxeo <packagers@nuxeo.com>"

# Copy Nuxeo distribution
COPY --from=builder /distrib $NUXEO_HOME

# Work around missing support for --chown flag with COPY instruction in Kaniko
# TODO NXP-28052: remove and use COPY --chown when fixed in Kaniko, or find a proper way
RUN chown -R 900:0 $NUXEO_HOME \
  && chmod -R g+rwX $NUXEO_HOME

# Run as a non root user with a fixed UID
USER 900