FROM ubuntu:16.04

ENV IGFS_USER=ignite \
    IGFS_LOG_DIR=/var/log/ignite \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    IGNITE_HOME=/ignite \
    HADOOP_HOME=/hadoop \
    HADOOP_CONF_DIR=/hadoop/etc/hadoop \
    HADOOP_CLASSPATH=/ignite/config:/hadoop/share/hadoop/common/lib/*:/hadoop/share/hadoop/common/*:/hadoop/share/hadoop/tools/*:hadoop/share/hadoop/tools/lib/* \
    IGNITE_CUSTOM_CLASSPATH=$HADOOP_CLASSPATH

RUN apt-get update && \
    apt-get install -y openjdk-8-jre-headless netcat-openbsd
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f && \
    rm -rf /var/lib/apt/lists/*
COPY ./hadoop /hadoop
COPY ./ignite /ignite
COPY ./templates /templates
COPY hadoop/share/hadoop/hdfs/lib/xercesImpl-2.9.1.jar /hadoop/share/hadoop/tools/lib/
COPY hadoop/share/hadoop/tools/lib/*.jar /hadoop/share/hadoop/common/lib/

RUN set -x \
    && useradd $IGFS_USER \
    && [ `id -u $IGFS_USER` -eq 1000 ] \
    && [ `id -g $IGFS_USER` -eq 1000 ] \
    && mkdir -p $IGFS_LOG_DIR /usr/share/ignite /usr/etc/ \
    && chown -R "$IGFS_USER:$IGFS_USER" $IGFS_LOG_DIR \
    && ln -s /ignite/config/ /usr/etc/ignite \
    && ln -s /ignite/bin/* /usr/bin \
