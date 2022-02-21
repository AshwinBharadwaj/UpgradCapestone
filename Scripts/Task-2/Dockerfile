FROM node:16

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
#COPY upg-loadme-app/package*.json ./

# Bundle app source
COPY package*.json /usr/src/app
COPY *.js /usr/src/app

WORKDIR /usr/src/app

RUN npm install
# If you are building your code for production
# RUN npm ci --only=production

EXPOSE 8081
CMD [ "node", "server.js" ]
