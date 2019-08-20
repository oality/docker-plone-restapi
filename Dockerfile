FROM plone:5.2-alpine

LABEL name="Plone 5.2 Python 3 plone.restapi for Docker" \
    description="Base on Plone official image, ready for production" \
    maintainer="Benoît Suttor"

COPY buildout-restapi.cfg /plone/instance/

RUN apk add --no-cache --virtual .build-deps \
    gcc \
    libc-dev \
    zlib-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libxml2-dev \
    libxslt-dev \
    pcre-dev \
    libffi-dev \
&& cd /plone/instance \
&& chown plone:plone /plone/instance/buildout-restapi.cfg \
&& su -c "buildout -c buildout-restapi.cfg" -s /bin/sh plone \
&& apk del .build-deps \
&& rm -rf /plone/buildout-cache/downloads/*

# EXPOSE 8080
# WORKDIR /plone/instance
COPY docker-entrypoint.sh /
HEALTHCHECK --interval=1m --timeout=5s --start-period=30s \
  CMD nc -z -w5 127.0.0.1 8080 || exit 1

VOLUME /data

# CMD ["start"]
