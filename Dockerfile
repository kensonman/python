#
FROM python:alpine

LABEL maintainer="Kenson Man <kenson@kenson.idv.hk>"
LABEL version="v1.1.0"

ENV WDIR=/usr/src/app

COPY scripts/entrypoint.sh /entrypoint.sh
RUN apk update && \
    apk add bash && \
	 apk add gettext && \
	 pip install --upgrade pip && \
	 chmod +x /entrypoint.sh && \
    mkdir -p $WDIR
WORKDIR $WDIR

ENTRYPOINT ["/entrypoint.sh"]
CMD ["run", "0.0.0.0:8000"]
EXPOSE 8000
