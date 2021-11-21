FROM adoptopenjdk/openjdk11:jdk-11.0.12_7-ubuntu
ENV GAUGE_ARCHIVE=gauge-1.4.1-linux.x86_64.zip
ENV GAUGE_TELEMETRY_ENABLED=false
ENV GAUGE_VERSION=1.4.1
ENV GAUGE_LOG_LEVEL="info"
ENV GAUGE_JVM_ARGS="-Dlogback.configurationFile=/common/logback.xml"
ENV DISPLAY=:0
COPY cli /cli/
COPY common /common/
COPY tests /tests/
ADD entrypoint.sh /entrypoint.sh
RUN set -ex && \
    apt-get update && \
    apt-get --no-install-recommends -y install wget unzip xvfb firefox libxext6 libxtst6 libxrender1 libnss3 && \
    wget -qnc "https://github.com/getgauge/gauge/releases/download/v$GAUGE_VERSION/$GAUGE_ARCHIVE" && \
    unzip $GAUGE_ARCHIVE -d /usr/local/bin && \
    rm -rf $GAUGE_ARCHIVE && \
    # do not check for updates
    gauge config check_updates false && \
    # install gauge plugins
    gauge install java --version 0.7.15 && \
    gauge install html-report && \
    gauge install xml-report && \
    gauge install spectacle && \
    gauge install screenshot && \
    gauge install reportserver && \
    gauge install reportportal && gauge -v && \
    chmod a+x /cli/cli.sh /cli/commands/e2etests.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/cli/cli.sh"]
