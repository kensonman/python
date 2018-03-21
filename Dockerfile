#
FROM python:3

LABEL maintainer="Kenson Man <kenson@kenson.idv.hk>"
LABEL version="v1.0.0"

COPY scripts/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["run"]
EXPOSE 8000
