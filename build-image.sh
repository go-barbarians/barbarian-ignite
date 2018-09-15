#!/bin/bash
#
# prerequisite - SSH access to github
#              - Membership Barbarians team with read access to github
#              - Ubuntu 16.04 LTS

CONTAINER_REPO=535272059665.dkr.ecr.eu-west-1.amazonaws.com

HADOOP_VERSION=2.8.4
IGNITE_BRANCH_VERSION=2.6
IGNITE_RELEASE_VERSION=2.5.0-SNAPSHOT #todo: change to release
PACKAGING_DIR=opt/barbarian

WORKING_DIR=`dirname $(readlink -f $0)`
TEMP_DIR=/work/temp #your choice here

mkdir -p $WORKING_DIR/$PACKAGING_DIR
mkdir -p $TEMP_DIR

pushd $TEMP_DIR

# build prerequisites
sudo apt-get -y install maven build-essential autoconf automake libtool cmake zlib1g-dev pkg-config libssl-dev libfuse-dev \
snappy libsnappy-dev autogen

# build protoc
wget https://github.com/protocolbuffers/protobuf/archive/v2.5.0.tar.gz
tar xzf v2.5.0.tar.gz
pushd ./protobuf-2.5.0
curl -L https://github.com/google/googletest/archive/release-1.5.0.tar.gz | tar zx
mv googletest-release-1.5.0 gtest
./autogen.sh
./configure
make
make check
sudo make install
sudo ldconfig
popd

# build hadoop
git clone git@github.com:go-barbarians/badh-hadoop.git
pushd ./badh-hadoop
git checkout branch-$HADOOP_VERSION
mvn clean package install -Pdist -Pnative -Drequire.snappy -Dbundle.snappy \
-Drequire.openssl -Dbundle.openssl -DskipTests=true \
-Dsnappy.lib=/usr/lib/x86_64-linux-gnu -Dopenssl.lib=/usr/lib/x86_64-linux-gnu

cp -R hadoop-dist/target/hadoop-$HADOOP_VERSION $WORKING_DIR/$PACKAGING_DIR/hadoop
#delete config directory
rm -rf $WORKING_DIR/$PACKAGING_DIR/hadoop/etc/hadoop
popd

# build ignite
# nb. ignite is a prereq for tez because need to bundle ignite JARs in tez application tarball
# nb. ignite-mesos module breaks the build and has been commented in pom.xml
git clone git@github.com:go-barbarians/badh-ignite.git
pushd ./badh-ignite
git checkout ignite-$IGNITE_BRANCH_VERSION
mvn clean package install -Prelease -Dignite.edition=hadoop -DskipTests -Dhadoop.version=$HADOOP_VERSION
cp -R target/release-package-hadoop $WORKING_DIR/$PACKAGING_DIR/ignite
#delete config directory
rm -rf $WORKING_DIR/$PACKAGING_DIR/ignite/config
popd
popd #back to working directory

sudo $(aws ecr get-login --no-include-email --region eu-west-1)
sudo docker build -t ignite .
sudo docker tag ignite:latest $CONTAINER_REPO/ignite:latest
sudo docker push $CONTAINER_REPO/ignite:latest

