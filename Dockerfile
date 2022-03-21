## Copyright 2020 Google LLC
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##      http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
#
#FROM registry.access.redhat.com/ubi8/nodejs-16:1-18 as base
#
#FROM base as builder
#
## Some packages (e.g. @google-cloud/profiler) require additional
## deps for post-install scripts
#USER root
#
#RUN dnf install --disableplugin=subscription-manager -y \
#    wget \
#    python3 \
#    make \
#    gcc-c++
#
#RUN GRPC_HEALTH_PROBE_VERSION=v0.4.6 && \
#    wget -qO/bin/grpc_health_probe https://github.com/grpc-ecosystem/grpc-health-probe/releases/download/${GRPC_HEALTH_PROBE_VERSION}/grpc_health_probe-linux-amd64 && \
#    chmod +x /bin/grpc_health_probe
#
#WORKDIR /usr/src/app
#
#COPY package*.json ./
#
#RUN npm install --only=production
#
#FROM base
#
#WORKDIR /usr/src/app
#
#COPY --from=builder /usr/src/app/node_modules ./node_modules
#
#COPY . .
#
#EXPOSE 7000
#
#ENTRYPOINT [ "node", "server.js" ]

###

FROM registry.access.redhat.com/ubi8/nodejs-12:1-70 AS builder

USER root

RUN yum install -y wget python3 make gcc-c++ && yum clean all

WORKDIR /opt/app-root/src

USER default

COPY . .

RUN npm install --only=production

FROM registry.access.redhat.com/ubi8/nodejs-12:1-70

COPY --from=builder /opt/app-root/src/node_modules node_modules

COPY . .

EXPOSE 7000

ENTRYPOINT [ "node" , "server.js" ]
