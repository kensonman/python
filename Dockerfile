#
FROM python:alpine

LABEL maintainer="Kenson Man <kenson@kenson.idv.hk>"
LABEL version="v1.1.0"

COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["run", "0.0.0.0:8000"]
EXPOSE 8000
