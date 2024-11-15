
FROM node:20-alpine AS build 

WORKDIR /app

# Копируем и устанавливаем зависимости
COPY package.json package-lock.json ./
RUN npm install

# Копируем исходный код и создаём сборку проекта
COPY . .
RUN npm run build

# Продуктивный этап с использованием Nginx
FROM nginx:1.17-alpine

# Копируем кастомный конфиг Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Открываем порт 80
EXPOSE 80

# Копируем файлы сборки в корневую директорию Nginx
COPY --from=build /app/dist /usr/share/nginx/html/petclinic
