FROM ubuntu:16.04

ENV IGFS_USER=hadoop \
    IGFS_LOG_DIR=/var/log/ignite \
    IGFS_WORK_DIR=/opt/barbarian/ignite/work \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    IGNITE_HOME=/opt/barbarian/ignite \
    IGNITE_CONF_DIR=/opt/barbarian/ignite/config \
    HADOOP_HOME=/opt/barbarian/hadoop \
    HADOOP_CONF_DIR=/opt/barbarian/hadoop/etc/hadoop \
    HADOOP_CLASSPATH=/opt/barbarian/ignite/config:/opt/barbarian/hadoop/share/hadoop/common/lib/*:/opt/barbarian/hadoop/share/hadoop/common/*:/opt/barbarian/hadoop/share/hadoop/tools/*:/opt/barbarian/hadoop/share/hadoop/tools/lib/* \
    IGNITE_CUSTOM_CLASSPATH=$HADOOP_CLASSPATH

RUN apt-get update && \
    apt-get install -y openjdk-8-jre-headless netcat-openbsd ca-certificates-java
RUN apt-get clean && \
    update-ca-certificates -f && \
    rm -rf /var/lib/apt/lists/*

COPY ./opt/barbarian /opt/barbarian
COPY ./opt/barbarian/hadoop/share/hadoop/hdfs/lib/xercesImpl-2.9.1.jar /opt/barbarian/hadoop/share/hadoop/tools/lib/
COPY ./opt/barbarian/hadoop/share/hadoop/tools/lib/*.jar /opt/barbarian/hadoop/share/hadoop/common/lib/

RUN set -x \
    && useradd $IGFS_USER \
    && [ `id -u $IGFS_USER` -eq 1000 ] \
    && [ `id -g $IGFS_USER` -eq 1000 ] \
    && mkdir -p $IGFS_LOG_DIR $IGFS_WORK_DIR \
    && chown -R "$IGFS_USER:$IGFS_USER" $IGFS_LOG_DIR \
    && chown -R "$IGFS_USER:$IGFS_USER" $IGFS_WORK_DIR \
    && ln -s /opt/barbarian/ignite/config/ /etc/ignite
