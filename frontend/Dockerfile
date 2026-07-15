FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN CYPRESS_INSTALL_BINARY=0 npm install

ENV REACT_APP_BACKEND_URL=/api

# Copia o restante do código e compila a aplicação
COPY . .
RUN npm run build

# NGINX
FROM nginx:alpine

# Copia a configuração customizada do NGINX
COPY --from=builder /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
