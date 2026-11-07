# Etapa 1: Build da aplicação Angular
FROM node:22-alpine AS build
WORKDIR /app

# Copia os arquivos de dependência e instala
COPY package*.json ./
RUN npm ci

# Copia o restante do código e gera o build de produção
COPY . .
RUN npm run build -- --configuration production

# Etapa 2: Servidor Nginx para a SPA
FROM nginx:alpine

# Remove a página padrão do Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copia os arquivos compilados do Angular (Atenção ao nome exato da pasta gerada)
COPY --from=build /app/dist/ADS_Equipe2_Biblioteca_Front/browser /usr/share/nginx/html

# Copia a configuração customizada do Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]