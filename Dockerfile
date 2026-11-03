FROM node:22-alpine AS build
WORKDIR /src
COPY package.json server.js order-service.js ./
COPY public ./public
RUN node --check server.js && node --check order-service.js && node --check public/app.js

FROM node:22-alpine AS runtime
ENV NODE_ENV=production PORT=3000
WORKDIR /app
COPY --from=build --chown=node:node /src/package.json /src/server.js /src/order-service.js ./
COPY --from=build --chown=node:node /src/public ./public
RUN mkdir -p /app/data && chown -R node:node /app
USER node
EXPOSE 3000
CMD ["node", "server.js"]
