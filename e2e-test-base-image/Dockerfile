FROM eclipse-temurin:25-jdk-noble
ARG GAUGE_VERSION=1.6.29
ARG GAUGE_ARCHIVE=gauge-${GAUGE_VERSION}-linux.x86_64.zip
ENV GAUGE_HOME=/usr/local/share/gauge
ENV GAUGE_TELEMETRY_ENABLED=false
ENV GAUGE_LOG_LEVEL="info"
ENV GAUGE_JVM_ARGS="-Dlogback.configurationFile=/common/logback.xml"
ENV JAVA_TOOL_OPTIONS="--enable-native-access=ALL-UNNAMED"
ENV DISPLAY=:0
ENV FIREFOX_BINARY=/usr/bin/firefox
COPY cli /cli/
COPY common /common/
COPY tests /tests/
COPY entrypoint.sh /entrypoint.sh
RUN set -ex && \
    # Install Mozilla's official Firefox .deb (Ubuntu Noble defaults to snap which doesn't work in Docker)
    apt-get update && \
    apt-get --no-install-recommends -y install software-properties-common && \
    add-apt-repository -y ppa:mozillateam/ppa && \
    printf 'Package: firefox*\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001\n' > /etc/apt/preferences.d/mozilla-firefox && \
    apt-get update && \
    apt-get --no-install-recommends -y install wget unzip xvfb firefox libxext6 libxtst6 libxrender1 libnss3 x11-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    wget -qnc "https://github.com/getgauge/gauge/releases/download/v$GAUGE_VERSION/$GAUGE_ARCHIVE" && \
    unzip $GAUGE_ARCHIVE -d /usr/local/bin && \
    rm -rf $GAUGE_ARCHIVE && \
    # set up shared gauge home
    mkdir -p "$GAUGE_HOME" && \
    # do not check for updates
    gauge config check_updates false && \
    # install gauge plugins
    gauge install java --version 1.0.1 && \
    gauge install html-report && \
    gauge install xml-report && \
    gauge install spectacle && \
    gauge install screenshot && \
    gauge install reportserver && \
    gauge install reportportal && gauge -v && \
    chmod a+x /cli/cli.sh /cli/commands/e2etests.sh /entrypoint.sh
RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix && \
    (getent group 1000 >/dev/null 2>&1 && groupdel $(getent group 1000 | cut -d: -f1) || true) && \
    (getent passwd 1000 >/dev/null 2>&1 && userdel $(getent passwd 1000 | cut -d: -f1) || true) && \
    groupadd --gid 1000 e2euser && \
    useradd --uid 1000 --gid 1000 -m e2euser && \
    mkdir -p /cli/logs && \
    chown -R e2euser:e2euser /cli /common /tests /entrypoint.sh "$GAUGE_HOME"
USER e2euser
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/cli/cli.sh"]
