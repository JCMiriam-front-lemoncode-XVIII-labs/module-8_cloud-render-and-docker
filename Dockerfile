FROM nginx:stable-alpine

ENV PORT=10000
COPY nginx/default.conf.template /etc/nginx/templates/default.conf.template
COPY index.html styles.css script.js /usr/share/nginx/html/
EXPOSE 10000
CMD ["nginx", "-g", "daemon off;"]
