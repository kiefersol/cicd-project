FROM docker.io/library/node:12.18.1-slim

COPY package.json /opt/microservices/
COPY ratings.js /opt/microservices/
WORKDIR /opt/microservices
RUN npm install

#hadolint ignore=DL3008

ARG service_version
ENV SERVICE_VERSION ${service_version:-v1}

EXPOSE 9080
CMD ["node", "/opt/microservices/ratings.js", "9080"]