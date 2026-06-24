FROM nginx:alpine

COPY website/index.html /usr/share/nginx/html/index.html

RUN mkdir -p /var/opt/nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]