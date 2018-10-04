FROM dockerbarbarians/barbarian-base:unstable

ENV IGFS_USER=hadoop \
    IGFS_LOG_DIR=/var/log/ignite \
    IGFS_WORK_DIR=/grid/0 \
    IGNITE_HOME=/opt/barbarian/ignite \
    IGNITE_CONF_DIR=/opt/barbarian/ignite/config \
    HADOOP_CLASSPATH=/opt/barbarian/ignite/config:/opt/barbarian/hadoop/share/hadoop/common/lib/*:/opt/barbarian/hadoop/share/hadoop/common/*:/opt/barbarian/hadoop/share/hadoop/tools/*:/opt/barbarian/hadoop/share/hadoop/tools/lib/* \
    IGNITE_CUSTOM_CLASSPATH=$HADOOP_CLASSPATH

COPY ./opt/barbarian /opt/barbarian
COPY ./opt/barbarian/ignite /opt/barbarian/ignite

# COPY ./opt/barbarian/hadoop/share/hadoop/hdfs/lib/xercesImpl-2.9.1.jar /opt/barbarian/hadoop/share/hadoop/tools/lib/
# COPY ./opt/barbarian/hadoop/share/hadoop/tools/lib/*.jar /opt/barbarian/hadoop/share/hadoop/common/lib/

RUN mkdir -p $IGFS_LOG_DIR \
    && chown -R $IGFS_USER $IGFS_LOG_DIR \
    && chgrp -R $IGFS_USER $IGFS_LOG_DIR \
    && ln -s /opt/barbarian/ignite/config /etc/ignite \
    && ln -s /opt/barbarian/control/nc /usr/bin/nc
