FROM nginx

COPY nginx.conf /etc/nginx/nginx.conf
COPY configurenginx.sh /opt/install/configurenginx.sh
COPY entrypoint.sh /opt/install/entrypoint.sh

RUN chmod +x /opt/install/configurenginx.sh \
    && chmod +x /opt/install/entrypoint.sh

ENTRYPOINT ["/opt/install/entrypoint.sh"]
