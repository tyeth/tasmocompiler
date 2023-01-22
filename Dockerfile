FROM node:12.16.2-buster-slim
LABEL maintainer="Piotr Antczak <antczak.piotr@gmail.com>"

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y python3 git python3-setuptools && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y python3-pip && pip3 install platformio && \
  DEBIAN_FRONTEND=noninteractive apt-get clean && \
  yarn global add nodemon && \
  cd /tmp && git clone https://github.com/tyeth/Tasmota.git && \
  rm -rf /var/lib/apt/lists/* 
ADD public /tasmocompiler/public/
ADD server /tasmocompiler/server/
ADD src /tasmocompiler/src/
ADD package.json yarn.lock .yarnrc /tasmocompiler/
RUN cd /tasmocompiler && git checkout add-sen5x && git branch -d development && git checkout -b development && yarn install && \
  yarn build && \
  yarn cache clean
  set PATH=/home/gitpod/.local/bin:$PATH
ENV LC_ALL=C.UTF-8 LANG=C.UTF-8
WORKDIR /tasmocompiler
ENTRYPOINT ["nodemon", "server/app.js"]
