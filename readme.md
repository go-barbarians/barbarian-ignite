# Barbarian Hadoop Distribution

[https://barbarians.io/](https://barbarians.io)

## Ignite Docker image

This repo contains the configuration files and build scripts for the Barbarian Hadoop Distribution **Ignite Docker image**.

The latest release of the Ignite Docker image is based on the following Apache Foundation software releases:
- Apache Ignite 2.6 (patched)

## Releases

| Release | Notes |
| -- | -- |
| 0.1-INTERNAL | Prelease PoC for demo |
| -- | -- |

## Building

**todo:** buildscripts missing

## Running

This image is designed to be run as a part of the Barbarian Hadoop distribution - a Kubernetes based platform for data processing at scale, founded on free software developed by the [Apache Software Foundation](https://www.apache.org/).

Launching this image is done using [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) and the provided [yaml](http://yaml.org) configuration file (see in the directory ./yaml). Successful deployment depends on:
- A running Kubernetes cluster with sufficient resource to deploy the full platform
- A running ZooKeeper ensemble
- An AWS S3 bucket as secondary filesystem
- Access keys for the S3 bucket
- An (internal, firewalled) webserver hosting the access keys

Launch a 2-node Ingite IGFS ensemble with ```kubectl create -f yaml/ignite.yaml```

## Features

The image includes support for the following features:
- Initpod to fetch AWS keys from remote webserver (path must be /ignite/init/aws.sh)
- Ignite IGFS cluster configured in DUAL_SYNC mode with S3 backing store
- IGFS health check monitoring
- Loadbalancer-based access

