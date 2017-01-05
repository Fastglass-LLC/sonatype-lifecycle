FROM alpine:3.4
ARG USER_HOME_DIR="/root"
MAINTAINER Brady Owens <brady@fastglass.net>

# Install cURL
RUN apk --update add curl ca-certificates tar
RUN curl -Ls https://github.com/sgerrand/alpine-pkg-glibc/releases/download/unreleased/glibc-2.23-r3.apk > /tmp/glibc-2.23-r3.apk
RUN apk add --allow-untrusted /tmp/glibc-2.23-r3.apk

# Java Version
ENV JAVA_VERSION_MAJOR 8
ENV JAVA_VERSION_MINOR 111
ENV JAVA_VERSION_BUILD 14
ENV JAVA_PACKAGE       jre
ENV SONATYPE_VERSION 1.24.0-02

# Download and unarchive Java
RUN mkdir /opt && curl -jksSLH "Cookie: oraclelicense=accept-securebackup-cookie"\
  http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-b${JAVA_VERSION_BUILD}/${JAVA_PACKAGE}-${JAVA_VERSION_MAJOR}u${JAVA_VERSION_MINOR}-linux-x64.tar.gz \
    | tar -xzf - -C /opt &&\
    ln -s /opt/${JAVA_PACKAGE}1.${JAVA_VERSION_MAJOR}.0_${JAVA_VERSION_MINOR} /opt/${JAVA_PACKAGE} &&\
    rm -rf /opt/${JAVA_PACKAGE}/*src.zip \
           /opt/${JAVA_PACKAGE}/lib/missioncontrol \
           /opt/${JAVA_PACKAGE}/lib/visualvm \
           /opt/${JAVA_PACKAGE}/lib/*javafx* \
           /opt/${JAVA_PACKAGE}/jre/lib/plugin.jar \
           /opt/${JAVA_PACKAGE}/jre/lib/ext/jfxrt.jar \
           /opt/${JAVA_PACKAGE}/jre/bin/javaws \
           /opt/${JAVA_PACKAGE}/jre/lib/javaws.jar \
           /opt/${JAVA_PACKAGE}/jre/lib/desktop \
           /opt/${JAVA_PACKAGE}/jre/plugin \
           /opt/${JAVA_PACKAGE}/jre/lib/deploy* \
           /opt/${JAVA_PACKAGE}/jre/lib/*javafx* \
           /opt/${JAVA_PACKAGE}/jre/lib/*jfx* \
           /opt/${JAVA_PACKAGE}/jre/lib/amd64/libdecora_sse.so \
           /opt/${JAVA_PACKAGE}/jre/lib/amd64/libprism_*.so \
           /opt/${JAVA_PACKAGE}/jre/lib/amd64/libfxplugins.so \
           /opt/${JAVA_PACKAGE}/jre/lib/amd64/libglass.so \
           /opt/${JAVA_PACKAGE}/jre/lib/amd64/libgstreamer-lite.so \
           /opt/${JAVA_PACKAGE}/jre/lib/amd64/libjavafx*.so \
           /opt/${JAVA_PACKAGE}/jre/lib/amd64/libjfx*.so \
    && mkdir /opt/sonatype && curl -jksSL https://download.sonatype.com/clm/server/nexus-iq-server-${SONATYPE_VERSION}-bundle.tar.gz | tar -xzf - -C /opt/sonatype

# Set environment
ENV JAVA_HOME /opt/${JAVA_PACKAGE}
ENV PATH ${PATH}:${JAVA_HOME}/bin
WORKDIR /opt/sonatype
EXPOSE 8070
ENTRYPOINT ["/opt/sonatype/demo.sh"]
