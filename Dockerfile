# Dockerfile
# 
# Author: 			Kenson Man <kenson@kenson.idv.hk>
# Last Modified: 	2018-03-24 09:22
# Desc:				The file used to create the container-image with python3. It is used to
#						create the container for Django development.
FROM python:alpine

LABEL maintainer="Kenson Man <kenson@kenson.idv.hk>"
LABEL version="v1.1.0"

ENV WDIR=/usr/src/app

COPY scripts/entrypoint.sh /entrypoint.sh
RUN apk add --update --no-cache bash gettext build-base postgresql-dev jpeg-dev\
		&& pip install --upgrade pip \
		&& pip install psycopg2 pillow \
		&& apk del build-base \
		&& chmod +x /entrypoint.sh \
		&& mkdir -p $WDIR
WORKDIR $WDIR

ENTRYPOINT ["/entrypoint.sh"]
CMD ["run", "0.0.0.0:8000"]
EXPOSE 8000
