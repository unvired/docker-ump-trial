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
      com.unvired.ump.release="R-3.002.0033" \
      com.unvired.ump.release-date="10-Dec-2015"

RUN mkdir -p /opt/unvired/temp \
	&& mkdir -p /var/UMPinput

RUN wget -q -O/opt/unvired/temp/UMP3_Docker.zip http://owncloud.unvired.com/index.php/s/p7qECutefEvRu9S/download

RUN unzip -qq /opt/unvired/temp/UMP3_Docker.zip -d /opt/unvired/UMP \
    && rm -f /opt/unvired/temp/UMP3_Docker.zip \
    && chmod +x /opt/unvired/UMP/bin/standalone.sh

RUN wget -q -O/opt/unvired/UMP/standalone/deployments/UMP.ear http://owncloud.unvired.com/index.php/s/LOgkvxDFIobz791/download
RUN wget -q -O/opt/unvired/UMP/modules/unvired/middleware/main/UMP_Core.jar http://owncloud.unvired.com/index.php/s/6BFU5uFnCE8026C/download
RUN wget -q -O/opt/unvired/UMP/modules/unvired/middleware/main/UMP_Logger.jar http://owncloud.unvired.com/index.php/s/sOifjJoPlbuQPSp/download
RUN wget -q -O/opt/unvired/UMP/modules/unvired/middleware/main/UMP_odata_sdk.jar http://owncloud.unvired.com/index.php/s/w4pYBiiEdbdhA5S/download
RUN wget -q -O/opt/unvired/UMP/modules/unvired/middleware/main/UMP_sapjco_sdk.jar http://owncloud.unvired.com/index.php/s/nAIrU66gAHA9E4d/download
RUN wget -q -O/opt/unvired/UMP/modules/unvired/middleware/main/UMP_jdbc_sdk.jar http://owncloud.unvired.com/index.php/s/5geoU5xBHIJJR0j/download
RUN wget -q -O/opt/unvired/UMP/standalone/configuration/hazelcast.xml http://owncloud.unvired.com/index.php/s/c6xIK2k8lJ4eJ4w/download
RUN wget -q -O/opt/unvired/UMP/standalone/configuration/standalone-full.xml http://owncloud.unvired.com/index.php/s/j5nomu9aoSPhH6v/download
RUN wget -q -O/etc/supervisor/conf.d/supervisord.conf http://owncloud.unvired.com/index.php/s/eYb0byRHzN1bWmg/download

ENV JBOSS_HOME=/opt/unvired/UMP
ENV DOCKER_UMP_VERSION=R-3.002.0033

EXPOSE 8080 9990

# Any files like SAP connection binaries can be passed in via this volume, the startup script will copy from here to start
VOLUME /var/UMPinput

ENTRYPOINT ["supervisord"]