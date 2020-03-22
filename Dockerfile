FROM alpine:latest

ENV V2RAY_VERSION v4.22.1
ENV PORT 10086
ENV SS_PASSWD u12345

USER root

COPY ws4ss.json /etc/

RUN apk upgrade --update \
    && apk add \
        bash \
        curl \
    # Install v2ray
    && mkdir /v2ray \
    && curl -L -H "Cache-Control: no-cache" -o /v2ray/v2ray.zip https://github.com/v2ray/v2ray-core/releases/download/${V2RAY_VERSION}/v2ray-linux-64.zip \
    && unzip /v2ray/v2ray.zip -d /v2ray/ && mv /etc/ws4ss.json /v2ray/ && chmod +x /v2ray \
    && sed -i "s/10086/$PORT/" /v2ray/ws4ss.json && sed -i "s/ss_passwd/$SS_PASSWD/" /v2ray/ws4ss.json \
    # clear
    && apk del curl && rm -rf /var/cache/apk/* /v2ray/v2ray.zip
    
CMD exec /v2ray/v2ray -config /v2ray/ws4ss.json
