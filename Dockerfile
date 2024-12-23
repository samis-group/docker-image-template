# First Stage
FROM ubuntu as base

# Labels
LABEL maintainer="Sami Shakir"
LABEL org.opencontainers.image.source="https://github.com/samis-group/docker-image-template"
LABEL org.opencontainers.image.description="Docker Image Description"

# Args and Env
ARG UID=1000
ARG UNAME=ubuntu
ENV TZ=Australia/Sydney

# run as user
USER ubuntu

# Copy docker-entrypoint.sh
COPY assets/docker-entrypoint.sh .
RUN chmod +x docker-entrypoint.sh

# Prod Stage
FROM base AS prod
ENV ENVIRONMENT=production
ENTRYPOINT ["./docker-entrypoint.sh"]

# Dev Stage
FROM base AS dev
ENV ENVIRONMENT=development
ENTRYPOINT ["./docker-entrypoint.sh"]
