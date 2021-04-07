# stage 1
FROM node:14-alpine as build-step
RUN mkdir -p /app
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
RUN ./node_modules/@angular/cli/bin/ng build
RUN cd dist && ls

# stage 2
FROM nginx:1.17.1-alpine as final
COPY --from=build-step /app/dist/eSewaMarriageServices /usr/share/nginx/html
EXPOSE 80
