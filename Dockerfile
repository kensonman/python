# Dockerfile
# 
# Author: 			Kenson Man <kenson@kenson.idv.hk>
# Last Modified: 	2018-03-24 09:22
# Desc:				The file used to create the container-image with python3. It is used to
#						create the container for Django development.
FROM python:alpine

LABEL maintainer="Kenson Man <kenson@kenson.idv.hk>"
LABEL version="v1.2.0"

ENV WDIR=/usr/src/app
ENV PYTHONPATH=/lib:/usr/lib

COPY scripts/entrypoint /entrypoint
RUN apk add --update --no-cache bash gettext build-base postgresql-dev jpeg-dev zlib-dev sudo \
		&& pip install --upgrade pip \
		&& pip install psycopg2 pillow \
		&& apk del build-base \
		&& chmod +x /entrypoint \
      && adduser -S theuser \
		&& mkdir -p $WDIR
WORKDIR $WDIR

ENTRYPOINT ["/entrypoint"]
CMD ["run", "0.0.0.0:8000"]
EXPOSE 8000
