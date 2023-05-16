FROM node as builder

WORKDIR /root/
COPY ["package.json", "package-lock.json", "./"]
COPY ["tsconfig.json", "./"]
RUN ["npm", "install", "--legacy-peer-deps"]
COPY ["src/", "./src/"]
RUN ["npm", "run", "build"]
RUN ["/bin/bash", "-c", "find . ! -name dist ! -name node_modules -maxdepth 1 -mindepth 1 -exec rm -rf {} \\;"]

FROM debian:11.2-slim

RUN apt-get update && \
 apt-get install -y \
    curl

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt install nodejs

WORKDIR /root/
COPY --from=builder /root/ ./
ENTRYPOINT ["node", "./dist/src"]
EXPOSE 3000
