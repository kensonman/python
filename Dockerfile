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
ENV PYTHONPATH=/lib:/usr/lib:/usr/local/lib/python3.7:/usr/local/lib/python3.7/site-packages

COPY scripts/entrypoint /entrypoint
RUN apk add --update --no-cache bash gettext build-base postgresql-dev jpeg-dev zlib-dev sudo python3-dev \
   && pip install --upgrade pip \
   && pip install psycopg2 pillow \
   && chmod +x /entrypoint \
   && adduser -Du 1000 theuser \
   && mkdir -p $WDIR \
   && echo "Finished"

WORKDIR $WDIR

ENTRYPOINT ["/entrypoint"]
CMD ["run", "0.0.0.0:8000"]
EXPOSE 8000
