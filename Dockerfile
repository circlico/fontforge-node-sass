# User official Node.js Docker image
FROM node:10.22.0-stretch

RUN mkdir -p /home/node/sass
WORKDIR /home/node/sass

ENV SASS_FORCE_BUILD 1
RUN npm install node-sass
RUN find /home/node/sass/node_modules/node-sass/vendor -name binding.node -exec mv {} /home/node/sass/binding.node \;

#Answer 'yes' to each question
ENV DEBIAN_FRONTEND noninteractive

# Do not manually bind node-sass
# RUN curl https://github.com/sass/node-sass/releases/download/v4.11.0/linux-x64-64_binding.node > /home/node/sass-binding/binding.node

ENV SASS_BINARY_PATH /home/node/sass/binding.node

# Upgrade the debian packages
RUN (apt-get update && apt-get upgrade -y -q && apt-get -y -q autoclean && apt-get -y -q autoremove)

#The official image comes with npm; so we can use it to install some packages
RUN npm install -g grunt-cli bower

# Install fontforge for our specific need
RUN apt-get update && apt-get install -y fontforge ttfautohint

# Change user. If you do not specify this command, the user will be root, and in our case,
# Bower will shout as it cannot be launched by root
USER node

# Specify a working directory on which the current user has write access
# Remember, a curl command will be, first, executed to download the worker
WORKDIR /home/node
