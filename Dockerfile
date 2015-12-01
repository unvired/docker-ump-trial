FROM ubuntu:14.04
MAINTAINER Unvired <support@unvired.io>

RUN apt-get update -y && apt-get install -y --no-install-recommends \
		ca-certificates \
		curl \
		wget \
        zip \
        unzip \
        supervisor \
        redis-server \
		openjdk-7-jre-headless \
		&& rm -rf /opt/lib/apt/lists/*

LABEL vendor="Unvired Inc." \
      com.unvired.ump.module="PLATFORM" \
      com.unvired.ump.release="R-3.002.0029" \
      com.unvired.ump.release-date="1-Dec-2015"

RUN mkdir -p /opt/unvired/temp

RUN wget -q --no-check-certificate -O/opt/unvired/temp/UMP3_Docker.zip https://www.dropbox.com/s/evjtpkz4u8sptsg/UMP3_Docker.zip

RUN unzip -qq /opt/unvired/temp/UMP3_Docker.zip -d /opt/unvired/UMP \
    && rm -f /opt/unvired/temp/UMP3_Docker.zip \
    && chmod +x /opt/unvired/UMP/bin/standalone.sh

RUN wget -q --no-check-certificate -O/opt/unvired/UMP/standalone/deployments/UMP.ear https://www.dropbox.com/s/d329zw55njfwn2x/UMP-R-3.002.0029.ear
RUN wget -q --no-check-certificate -O/opt/unvired/UMP/modules/unvired/middleware/main/UMP_Core.jar https://www.dropbox.com/s/p69y10j3zdzj36i/UMP_Core-R-3.002.0029.jar
RUN wget -q --no-check-certificate -O/opt/unvired/UMP/modules/unvired/middleware/main/UMP_Logger.jar https://www.dropbox.com/s/3a6elt8gxq0bso5/UMP_Logger-R-3.002.0029.jar
RUN wget -q --no-check-certificate -O/opt/unvired/UMP/modules/unvired/middleware/main/UMP_odata_sdk.jar https://www.dropbox.com/s/ot0mq0g5dxqzx8h/UMP_odata_sdk-R-3.002.0029.jar
RUN wget -q --no-check-certificate -O/opt/unvired/UMP/modules/unvired/middleware/main/UMP_sapjco_sdk.jar https://www.dropbox.com/s/fjind0lck9vflfy/UMP_sapjco_sdk-R-3.002.0029.jar
RUN wget -q --no-check-certificate -O/opt/unvired/UMP/modules/unvired/middleware/main/UMP_jdbc_sdk.jar https://www.dropbox.com/s/0g4o6l8rfto6qd2/UMP_jdbc_sdk-R-3.002.0029.jar
RUN wget -q --no-check-certificate -O/opt/unvired/UMP/standalone/configuration/hazelcast.xml https://www.dropbox.com/s/tix8o7m7vt4x0s2/hazelcast.xml
RUN wget -q --no-check-certificate -O/opt/unvired/UMP/standalone/configuration/standalone-full.xml https://www.dropbox.com/s/12z93s6991a15xd/standalone-full.xml
RUN wget -q --no-check-certificate -O/etc/supervisor/conf.d/supervisord.conf https://www.dropbox.com/s/ndxmwyzl35ehghv/supervisord.conf

ENV JBOSS_HOME=/opt/unvired/UMP
ENV DOCKER_UMP_VERSION=R-3.002.0029

EXPOSE 8080 9990

ENTRYPOINT ["supervisord"]